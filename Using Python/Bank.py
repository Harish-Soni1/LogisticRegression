import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sbn
%matplotlib inline

## Bank Data

bank=pd.read_csv("E:\\itsstudytym\\assignments\\LR\\bank-full LR.csv")
bank.head()

bank.isnull().sum()

for feature in bank.columns:
    sbn.countplot(feature,data=bank)
    plt.xlabel(feature)
    plt.ylabel('Y')
    plt.title(feature)
    plt.show()

bank.head()

bank.iloc[:,:].corr()

category=[feature for feature in bank.columns if bank[feature].dtypes=='O']
category

for feature in category:
    if feature!='y':
        bank[feature]=pd.get_dummies(bank[feature],drop_first=True)

bank.head()

X=bank.iloc[:,:-1]

y=bank['y']

from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test=train_test_split(X,y,test_size=0.3,random_state=False)

from sklearn.linear_model import LogisticRegression
LRM=LogisticRegression()
LRM.fit(X_train,y_train)

y_pred=LRM.predict(X_test)

from sklearn.metrics import classification_report
classification_report(y_pred,y_test)

from sklearn.metrics import confusion_matrix
confusion_matrix(y_test,y_pred)

from sklearn.metrics import accuracy_score
accuracy_score(y_test,y_pred)
