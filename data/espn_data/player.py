import numpy as np
import pandas as pd
import requests
from bs4 import BeautifulSoup
from datetime import datetime, date

columns = ['playerId','playerName','SEASON','TEAM','avg_GP','avg_GS','avg_MIN','avg_FGM_A','avg_FGpercent','avg_ThreePM_A','avg_ThreePpercent','avg_FTM_A','avg_FTpercent','avg_OR','avg_DR','avg_REB','avg_AST','avg_BLK','avg_STL','avg_PF','avg_TO','avg_PTS','total_FGM_A','total_FGpercent','total_ThreePM_A','total_ThreePpercent','total_FTM_A','total_FTpercent','total_OR','total_DR','total_REB','total_AST','total_BLK','total_STL','total_PF','total_TO','total_PTS','misc_total_DBLDBL','misc_total_TRIDBL','misc_total_DQ','misc_total_EJECT','misc_total_TECH','misc_total_FLAG','misc_total_AST_TO','misc_total_STL_TO','misc_total_RAT','misc_total_SCEFF','misc_total_SHEFF']
frame = pd.DataFrame(columns=columns)
BASE_URL = 'http://espn.go.com/nba/player/stats/_/id/{0}'

with open('playerList.data') as playerList:
    for i, playerId in enumerate(playerList):
        playerId = playerId.strip()
        print playerId.strip(), i
        url = BASE_URL.format(playerId)
        request = requests.get(url)
        body = BeautifulSoup(request.text)
        tables = body.find_all('table')
        h1 = body.find_all('h1')
        name = h1[1].text
        try:
            years = tables[1].find_all('tr', class_=['oddrow','evenrow'])
        except:
            continue
        array = np.zeros((len(years), len(columns)), dtype=object)
        array[:] = np.nan
        for i, year in enumerate(years):
            cols = year.find_all('td')
            array[i,0] = str(playerId)
            array[i,1] = name
            array[i,2] = cols[0].text
            try:
                array[i,3] = cols[1].a['href'].split('/')[7]
            except:
                pass
            for j in range(2,20):
                array[i, j+2] = cols[j].text
        years = tables[2].find_all('tr', class_=['oddrow','evenrow'])
        for i, year in enumerate(years):
            cols = year.find_all('td')
            for j in range(0,15):
                array[i, j+22] = cols[j+2].text
        years = tables[3].find_all('tr', class_=['oddrow','evenrow'])
        for i, year in enumerate(years):
            cols = year.find_all('td')
            for j in range(0,11):
                array[i, j+37] = cols[j+2].text
        for x in array:
            line = x.reshape(1,len(columns))
            new = pd.DataFrame(line, columns=frame.columns)
            frame = frame.append(new)

frame = frame.set_index(['playerId'])
frame.to_csv('player.csv')