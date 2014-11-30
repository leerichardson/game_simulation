feature table:
    gameScore_rates.csv

features:
    avg_scoreDiff: for this home team and visit team in previous year, the avg difference of scores 
    avg_homeWin: for this home team and visit team in previous year, the avg win/lose
    avg_scoreDiff_home: for this home team in previous year, the avg difference of scores 
    avg_win_home: for this home team in previous year, the avg win/lose
    avg_scoreDiff_visit: for this visit team in previous year, the avg difference of scores 
    avg_win_visit: for this visit team in previous year, the avg win/lose

nbaRegression.py
    regression trials.
    classifiers tried:
        tree.DecisionTreeClassifier,
        tree.ExtraTreeClassifier()
        RandomForestClassifier(n_estimators=100)
        ExtraTreesClassifier(n_estimators=100)
        GradientBoostingClassifier(n_estimators=100)
        linear_model.Lasso()
        LogisticRegression()
        svm.SVC(kernel='rbf', gamma=0.7, C=1.0)
        svm.LinearSVC(C=1.0)
    best sofar:
        lasso
        2009 0.653658536585
        2010 0.681300813008
        2011 0.665656565657
        2012 0.682668836452
        2013 0.641463414634

        linearSVC
        2009 0.659349593496
        2010 0.610569105691
        2011 0.653535353535
        2012 0.689178193653
        2013 0.638211382114
        