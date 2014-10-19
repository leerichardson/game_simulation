
fileList = [
'gameDetail_2009_2011_1.csv',
'gameDetail_2009_2011_2.csv',
'gameDetail_2009_2011_3.csv',
'gameDetail_2009_2011_4.csv',
'gameDetail_2009_2011_5.csv',
'gameDetail_2009_2011_6.csv',
'gameDetail_2012.csv',
'gameDetail_2013.csv',
'gameDetail_2014_1.csv',
'gameDetail_2014_2.csv',
]


s = set()
for f in fileList:
    with open(f) as file:
        for line in file:
            try:
                id = int(line.strip().split(',')[2])
                s.add(id)
            except:
                pass
    
with open('playerList.data', 'w') as f:    
    for id in sorted(list(s)):
        print >> f, id