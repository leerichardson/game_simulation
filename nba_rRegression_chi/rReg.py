
import sqlite3
numPlayers = 10
conn = sqlite3.connect('nba.db')
c = conn.cursor()
c2 = conn.cursor()
teamYear_to_row = dict()
gameSet = set()
def teamYearToRow(team,year):
    result = ''
    for line in c2.execute('select * from gameYearPlayerNotNull where game_year = '+str(year)+' and team = \''+ team +'\' order by minutes_year desc limit '+str(numPlayers)):
        result +=','
        result += (','.join([str(line[x]) for x in range(7,57)]))
        result +='\n'
    return result
    
fout = open('regTable.sql','w')    
print >> fout, 'begin transaction;'
for row in c.execute('select * from gameScore order by game_year asc'):
    match_id, date,home,homeScore, visit, visitScore,year=row
    if (home,visit,year) in gameSet or year==2009:
        continue
    gameSet.add((home, visit, year))
    sql = teamYear_to_row.get((home, year))
    if sql is None:
        sql = teamYearToRow(home, year)
        teamYear_to_row[(home, year)] = sql
    print >> fout, 'insert into regTable values (\'' + '\',\''.join([str(x) for x in (match_id, date, home, visit)])+'\','
    print >> fout, ','.join([str(x) for x in (homeScore, visitScore, (1 if int(homeScore)>int(visitScore) else 0))])
    print >> fout, sql
    sql = teamYear_to_row.get((visit, year))
    if sql is None:
        sql = teamYearToRow(visit, year)
        teamYear_to_row[(visit, year)] = sql
    print >> fout, sql    
    print >> fout, ');'

print >> fout, 'commit transaction;'
fout.close()