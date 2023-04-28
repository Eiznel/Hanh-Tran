import requests

def get_reviews(appid, params={'json':1}):
       url = 'https://store.steampowered.com/appreviews/'
       response = requests.get(url=url+appid, params=params, headers={'User-Agent': 'Mozilla/5.0'})
       return response.json()

def get_n_reviews(appid, n=100):
   reviews = []
   cursor = '*'
   params = {
           'json' : 1,
           'filter' : 'all',
           'language' : 'english',
           'day_range' : 9223372036854775807,
           'review_type' : 'all',
           'purchase_type' : 'all'
           }

   while n > 0:
       params['cursor'] = cursor.encode()
       params['num_per_page'] = min(100, n)
       n -= 100

       response = get_reviews(appid, params)
       cursor = response['cursor']
       reviews += response['reviews']

       if len(response['reviews']) < 100: break

   return reviews

from bs4 import BeautifulSoup
def get_n_appids(n=100, filter_by='topsellers'):
    appids = []
    url = f'https://store.steampowered.com/search/?category1=998&filter={filter_by}&page='
    page = 0

    while page*25 < n:
        page += 1
        response = requests.get(url=url+str(page), headers={'User-Agent': 'Mozilla/5.0'})
        soup = BeautifulSoup(response.text, 'html.parser')
        for row in soup.find_all(class_='search_result_row'):
            appids.append(row['data-ds-appid'])

    return appids[:n]

import pandas as pd
reviews = []
appids = get_n_appids(500)
for appid in appids:
   reviews += get_n_reviews(appid, 100)
df = pd.DataFrame(reviews)[['review', 'voted_up']]
df.to_csv('steam_reviews.csv', index=False)


