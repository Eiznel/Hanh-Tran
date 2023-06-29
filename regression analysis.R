# Load necessary packages
library(dplyr)

# Import data
data <- read.csv("data_with_allscores.csv")

# Fit simple linear regression models
model1 <- lm(playtime_forever ~ playability_score, data = data)
model2 <- lm(playtime_forever ~ narrative_interest_score, data = data)
model3 <- lm(playtime_forever ~ audiovisual_design_score, data = data)
model4 <- lm(playtime_forever ~ personal_gratification_score, data = data)

# Test associations between game mechanics and level of engagement
summary(model1)
summary(model2)
summary(model3)
summary(model4)

install.packages("mediation")

# Load mediation package
library(mediation)

# Fit mediation models
mediation_model1 <- lm(sentiment_score ~ playability_score, data = data)
mediation_model2 <- lm(sentiment_score ~ narrative_interest_score, data = data)
mediation_model3 <- lm(sentiment_score ~ audiovisual_design_score, data = data)
mediation_model4 <- lm(sentiment_score ~ personal_gratification_score, data = data)

# Test indirect effects
indirect1 <- mediate(model1, mediation_model1, treat = "playability_score", mediator = "sentiment_score", robustSE = TRUE)
indirect2 <- mediate(model2, mediation_model2, treat = "narrative_interest_score", mediator = "sentiment_score", robustSE = TRUE)
indirect3 <- mediate(model3, mediation_model3, treat = "audiovisual_design_score", mediator = "sentiment_score", robustSE = TRUE)
indirect4 <- mediate(model4, mediation_model4, treat = "personal_gratification_score", mediator = "sentiment_score", robustSE = TRUE)

# Test significance of indirect effects
summary(indirect1)
summary(indirect2)
summary(indirect3)
summary(indirect4)
