library(readr)
library(dplyr)
library(stringr)
library(tm)
library(textclean)
library(textstem)
library(stringr)

# DATA PREPROCESSING
steam_reviews <- read_csv("steam_data.csv") # Loading data

steam_reviews$review <- gsub("http\\S+|www\\S+|\\S+@\\S+|\\d{10}", "", steam_reviews$review)  # Remove URLs, emails, and phone numbers
steam_reviews$review <- str_remove_all(steam_reviews$review, "[[:punct:]]")  # Remove punctuations

steam_reviews$review <- str_remove_all(steam_reviews$review, "<.*?>")  # Remove HTML tags
steam_reviews$review <- str_replace_all(steam_reviews$review, "[^[:alnum:][:space:]]", "")  # Remove symbols and pictographs

steam_reviews$review <- removeWords(steam_reviews$review, stopwords("en")) # Remove stop words

steam_reviews$review <- tolower(steam_reviews$review) # Convert to lower case
steam_reviews$review <- replace_contraction(steam_reviews$review)  # Expand contractions
steam_reviews$review <- lemmatize_words(steam_reviews$review) # Lemmatization

steam_reviews <- distinct(steam_reviews) # Remove duplicates

steam_reviews <- steam_reviews %>%
  filter(trimws(review) != "") # Remove empty reviews after preprocessing

steam_reviews$review <- str_trim(steam_reviews$review)
steam_reviews$review <- str_squish(steam_reviews$review) # Remove extra white space

# Remove least frequent words
## Calculate amount of word appearances in reviews 
library(tidytext)
token_data <- steam_reviews %>% unnest_tokens(word, review)
word_reviews_count <- token_data %>%
  distinct(steamid, word) %>%
  count(word, sort = TRUE)
## Filter words that appear only once in each review 
filtered_reviews <- steam_reviews %>%
  mutate(review = strsplit(review, "\\s+")) %>%
  unnest(review) %>%
  left_join(word_reviews_count, by = c("review" = "word")) %>%
  filter(is.na(n) | n > 1) %>%
  group_by(appid, steamid, voted_up, playtime_forever) %>%
  summarise(review = paste(review, collapse = " "))

write.csv(filtered_reviews, "cleaned_reviews.csv", row.names = FALSE)

