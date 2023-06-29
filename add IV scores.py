import pandas as pd

# Load steam data
steam_data = pd.read_csv('clean_reviews.csv')

# Load keywords
keywords = pd.read_csv('keywords.csv')

# Iterate through each row in the steam_data file
for index, row in steam_data.iterrows():
    playability_score = 0
    narrative_interest_score = 0
    audiovisual_design_score = 0
    personal_gratification_score = 0
    
    review_text = row['review_text']
    
    # Check each keyword column for matches in the review text
    for keyword in keywords['playability']:
        if keyword in review_text:
            playability_score += 1
    
    for keyword in keywords['narrative interest']:
        if keyword in review_text:
            narrative_interest_score += 1
    
    for keyword in keywords['audiovisual design']:
        if keyword in review_text:
            audiovisual_design_score += 1
    
    for keyword in keywords['personal gratification']:
        if keyword in review_text:
            personal_gratification_score += 1
    
    # Assign the scores to the corresponding columns in the steam_data dataframe
    steam_data.at[index, 'playability_score'] = playability_score
    steam_data.at[index, 'narrative_interest_score'] = narrative_interest_score
    steam_data.at[index, 'audiovisual_design_score'] = audiovisual_design_score
    steam_data.at[index, 'personal_gratification_score'] = personal_gratification_score

# Save the updated steam_data dataframe back to the CSV file
steam_data.to_csv('data_with_scores.csv', index=False)

