
fout = open('regTableCreate.sql','w')
print >> fout,'''
create table regTable(
    match_id varchar(50), 
    gameDate varchar(20), 
    homeTeam varchar(10), 
    visitTeam varchar(10),
    homeScore integer, 
    visitScore integer,
    homeWin 
'''
with open('tmpsql.txt') as fin:
    l = list()
    for line in fin:
        l.append(line.strip().split(' ')[0])
for i in range(10):
    for x in l:
        print >> fout, '    ,'+x+'_home_'+str(i)+' float'
for i in range(10):
    for x in l:
        print >> fout, '    ,'+x+'_visit_'+str(i)+' float'

print >> fout, ');'
fout.close()