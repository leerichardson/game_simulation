import numpy as np
import pandas as pd
import requests
from bs4 import BeautifulSoup
from datetime import datetime, date

games = pd.read_csv('games_2009_2011_6.csv')
games.set_index('match_id')
BASE_URL = 'http://espn.go.com/nba/boxscore?gameId={0}'

request = requests.get(BASE_URL.format(games['match_id'][0]))

table = BeautifulSoup(request.text).find('table', class_='mod-data')
heads = table.find_all('thead')
headers = heads[0].find_all('tr')[1].find_all('th')[1:]
headers = [th.text for th in headers]
columns = ['match_id', 'team', 'playerId'] + headers
players = pd.DataFrame(columns=columns)

def get_players(players, team_name, matchId):
    array = np.zeros((len(players), len(headers)+1), dtype=object)
    array[:] = np.nan
    for i, player in enumerate(players):
        cols = player.find_all('td')
        if cols[1].text.startswith('DNP') or cols[1].text.startswith('NWT'):
            continue
        array[i, 0] = cols[0].a['href'].split('/')[7]
        for j in range(1, len(headers) + 1):
            array[i, j] = cols[j].text
    frame = pd.DataFrame(columns=columns)
    for x in array:
        line = np.concatenate(([matchId, team_name], x)).reshape(1,len(columns))
        new = pd.DataFrame(line, columns=frame.columns)
        frame = frame.append(new)
    return frame

for index, row in games.iterrows():
    print(index), row['match_id']
    request = requests.get(BASE_URL.format(row['match_id']))
    bodies = BeautifulSoup(request.text).find_all('tbody')
    team_1 = 'visit'
    team_1_players = bodies[0].find_all('tr') + bodies[1].find_all('tr')
    team_1_players = get_players(team_1_players, team_1, row['match_id'])
    players = players.append(team_1_players)
    team_2 = 'home'
    team_2_players = bodies[3].find_all('tr') + bodies[4].find_all('tr')
    team_2_players = get_players(team_2_players, team_2, row['match_id'])
    players = players.append(team_2_players)


players = players.set_index(['match_id'])
players.to_csv('gameDetail_2009_2011_6.csv')