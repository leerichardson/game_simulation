import numpy
import scipy
import pandas
import sklearn
from sklearn.linear_model import LogisticRegression
import csv
import random
from sklearn.feature_selection import VarianceThreshold
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import LinearSVC
from sklearn import mixture
from sklearn import svm
from sklearn import linear_model
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier,GradientBoostingClassifier
from sklearn import tree

dataIn = r'gameScore_rates.csv'
df = pandas.read_csv(dataIn)

grouped = df['homeWin'].groupby(df['game_year'])
print grouped.mean()

columnsToDelete = set(['home_team_score','visit_team_score','match_id',
'gameDate','homeTeam','visitTeam','homeScore','visitScore','game_year',
'nextYear','home_team','visit_team', 'gameYear','homeWin', u'avg_scoreDiff', 
u'avg_homeWin', u'avg_scoreDiff_home', u'avg_win_home', u'avg_scoreDiff_visit', u'avg_win_visit'])

xColumns = []
for x in df.columns:
    if x not in columnsToDelete and ':' not in x:
        xColumns.append(x)

columnsToDeleteRPM = set(['home_team_score','visit_team_score','match_id',
'gameDate','homeTeam','visitTeam','homeScore','visitScore','game_year',
'nextYear','home_team','visit_team', 'gameYear','homeWin', u'avg_scoreDiff', 
u'avg_homeWin', u'avg_scoreDiff_home', u'avg_win_home', u'avg_scoreDiff_visit', u'avg_win_visit', u'PER_weight_0', u'PER_weight_1'])   

xColumnsRPM = []
for x in df.columns:
    if x not in columnsToDeleteRPM and ':' not in x:
        xColumnsRPM.append(x)

columnsToDeletePER = set(['home_team_score','visit_team_score','match_id',
'gameDate','homeTeam','visitTeam','homeScore','visitScore','game_year',
'nextYear','home_team','visit_team', 'gameYear','homeWin', u'avg_scoreDiff', 
u'avg_homeWin', u'avg_scoreDiff_home', u'avg_win_home', u'avg_scoreDiff_visit', u'avg_win_visit', u'RPM_weight_0', u'ORPM_weight_0', 
u'DRPM_weight_0', u'RPM_weight_1', u'ORPM_weight_1', u'DRPM_weight_1'])   

xColumnsPER = []
for x in df.columns:
    if x not in columnsToDeletePER and ':' not in x:
        xColumnsPER.append(x)

def scale(df):
    tmp = pandas.DataFrame(df)
    for col in tmp.columns:
        if tmp[col].min() <0:
            data = abs(tmp[col].min())
            tmp[col] = tmp[col].apply(lambda x: x+data)
            maxV = float(tmp[col].max())
            if maxV ==0:
                continue
            tmp[col] = tmp[col].apply(lambda x: x/maxV)
    return tmp
    
#logistic. best so far
for year in range(2009,2014):
    train = df[df['game_year']<year]
    test = df[df['game_year']==year]
    xTrain = scale(train[xColumns])
    yTrain = train['homeWin']
    xTest = scale((test[xColumns]))
    yTest = test['homeWin']
    logreg = LogisticRegression()
    logreg.fit(xTrain, yTrain)
    yHat = logreg.predict(xTest)
    print year, sum([1 - abs(x) for x in (yHat - yTest)]) / float(len(yHat))

train = df[df['game_year']<2013]
test = df[df['game_year']==2013]
xTrain = scale(train[xColumns])
yTrain = train['homeWin']
xTest = scale((test[xColumns]))
yTest = test['homeWin']
logreg = LogisticRegression()
logreg.fit(xTrain, yTrain)
yHat = logreg.predict(xTest)
print sum([1 - abs(x) for x in (yHat - yTest)]) / float(len(yHat))

#compare all for each year
naive_bayes = GaussianNB()
treeClf = tree.DecisionTreeClassifier()
extraTtreeClf = tree.ExtraTreeClassifier()
randomTreeClf = RandomForestClassifier(n_estimators=100)
extraTreeClf = ExtraTreesClassifier(n_estimators=100)
gBoostTreeClf = GradientBoostingClassifier(n_estimators=100)
lassoClf = sklearn.linear_model.Lasso()
logiClf = LogisticRegression()
rbf_svc = svm.SVC(kernel='rbf', gamma=0.7, C=1.0)
lin_svc = svm.LinearSVC(C=1.0)
for clf in [treeClf,extraTtreeClf,randomTreeClf,extraTreeClf,gBoostTreeClf,lassoClf,logiClf,rbf_svc, lin_svc, naive_bayes]:
    print clf
    for year in range(2009,2014):
        train = df[df['game_year']<year]
        test = df[df['game_year']==year]
        xTrain = scale(train[xColumnsRPM])
        yTrain = train['homeWin']
        yTest = test['homeWin']
        xTest = scale((test[xColumnsRPM]))
        yHat = clf.fit(xTrain, yTrain).predict(xTest)
        print year, sum([1 - abs(x) for x in (yHat - yTest)]) / float(len(yTest))
       
    
#compare all to predict last year
train = df[df['game_year']<2013]
test = df[df['game_year']==2013]
xTrain = scale(train[xColumns])
yTrain = train['homeWin']
xTest = scale((test[xColumns]))
yTest = test['homeWin']
treeClf = tree.DecisionTreeClassifier()
extraTtreeClf = tree.ExtraTreeClassifier()
randomTreeClf = RandomForestClassifier(n_estimators=100)
extraTreeClf = ExtraTreesClassifier(n_estimators=100)
gBoostTreeClf = GradientBoostingClassifier(n_estimators=100)
lassoClf = sklearn.linear_model.Lasso()
logiClf = LogisticRegression()
rbf_svc = svm.SVC(kernel='rbf', gamma=0.7, C=1.0)
lin_svc = svm.LinearSVC(C=1.0)
for clf in [treeClf,extraTtreeClf,randomTreeClf,extraTreeClf,gBoostTreeClf,lassoClf,logiClf,rbf_svc, lin_svc]:
    yHat = clf.fit(xTrain, yTrain).predict(xTest)
    print sum([1 - abs(x) for x in (yHat - yTest)]) / float(len(yHat))
