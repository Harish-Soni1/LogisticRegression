import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sbn
%matplotlib inline


## Credit Card

credit=pd.read_csv("E:\\itsstudytym\\assignments\\LR\\creditcard LR.csv")

credit.head()

credit=credit.drop('Unnamed: 0',axis=1)

credit.isnull().sum()

for feature in credit.columns:
    sbn.countplot(feature,data=credit)
    plt.xlabel(feature)
    plt.ylabel('Card')
    plt.title(feature)
    plt.show()

for feature in credit.columns:
    if feature!='owner' and feature!='selfemp':
        plt.hist(feature,data=credit,bins=3)
        plt.xlabel(feature)
        plt.ylabel('Card')
        plt.title(feature)
        plt.show()

credit['owner']=pd.get_dummies(credit['owner'],drop_first=True)
credit['selfemp']=pd.get_dummies(credit['selfemp'],drop_first=True)

credit.head()

X=credit.iloc[:,1:]
y=credit.iloc[:,:1]

from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test=train_test_split(X,y,test_size=0.3,random_state=False)

from sklearn.linear_model import LogisticRegression
LRM=LogisticRegression()
LRM.fit(X_train,y_train)

y_pred=LRM.predict(X_test)

classification_report(y_test,y_pred)

confusion_matrix(y_test,y_pred)

accuracy_score(y_test,y_pred)
