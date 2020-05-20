rm(list=ls())
cat("\14")

library(tidyverse)
library(ggplot2)

# EDA
bank_data<-read.csv("E:/itsstudytym/assignments/LR/bank-full LR.csv")
sum(is.na(bank_data))

bank_data<-bank_data[,-c(2,3,4,9,14)]
str(bank_data)

bankNum<-bank_data[1:45211,c(1,3,6,8,9,10,12)]
bankNum

loan<-as.numeric(bank_data$loan)
housing<-as.numeric(bank_data$housing)
month<-as.numeric(bank_data$month)
default<-as.numeric(bank_data$default)
bankNum<-cbind(bankNum,loan,housing,month,default)

bankNum<-bankNum[,-7]

#visualization
#box plot
for (i in 1:10){
  data<-bankNum[,i]
  boxplot(data)
}

#histogram
for (i in 1:10){
  data<-bankNum[,i]
  hist(data,xlab=colnames(bankNum[i]))
}

#plot
for (i in 1:10){
  data<-bankNum[,i]
  plot(data,xlab=colnames(bankNum[i]))
}

#normalize
normalize<-function(x){
  return(x-min(x))/(std(x)-min(x))
}
bank_norm <- as.data.frame(lapply(bankNum, normalize))

bank_norm<-cbind(bankNum,bank_data$y)
names(bank_norm)[names(bank_norm)=='bank_data$y']<-'y'
bank_norm<-bank_norm[,-12]

#modelling
model<-glm(y~.,data=bank_norm,family="binomial")
car::vif(model)
MASS::stepAIC(model)
summary(model)

m<-glm(formula = y ~ age + balance + day + duration + campaign + 
         previous + loan + housing + default, family = "binomial", 
       data = bank_norm)
summary(m)
plot(m)

#iteration
data<-bank_norm[-c(24149,29183,44603),]
m1<-glm(formula = y ~ age + balance + day + duration + campaign + 
          previous + loan + housing + default, family = "binomial", 
        data = data)
summary(m1)
plot(m1)

#iteration2
data1<-bank_norm[-c(1787,2888,3332,19640,21096,24149,29183,44603),]
m2<-glm(formula = y ~ age + balance + day + duration + campaign + 
          previous + loan + housing + default, family = "binomial", 
        data = data1)
summary(m2)

##confusion matrix table
prob<-predict(m2,bank_norm,type="response")
prob

##Confusion matrix and considering the threshold value as 0.5
conf<-table(prob>0.5,bank_norm$y)
conf

##model accuracy
acc<-sum(diag(conf)/sum(conf))
acc

##ROC
library(ROCR)
rocrpred<-prediction(prob,bank_data$y)
rocrperf<-performance(rocrpred,'tpr','fpr')
plot(rocrperf,colorize=T,text.adj=c(-0.2,1.7))
