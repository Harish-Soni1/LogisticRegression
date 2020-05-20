rm(list=ls())
cat("\14")

#EDA
credit_data<-read.csv("E:/itsstudytym/assignments/LR/creditcard LR.csv")
str(credit_data)
sum(is.na(credit_data))

credit<-credit_data[1:1319,c(2,3,4,5,6,7,10,11,12,13)]
str(credit)

owner<-as.numeric(credit_data$owner)
selfemp<-as.numeric(credit_data$selfemp)

creditNum<-cbind(credit,owner,selfemp)
creditNum<-creditNum[,-1]

#visualization
#box plot
for (i in 1:10){
  data<-creditNum[,i]
  boxplot(data)
}

#histogram
for (i in 1:10){
  data<-creditNum[,i]
  hist(data,xlab=colnames(creditNum[i]))
}

#plot
for (i in 1:10){
  data<-creditNum[,i]
  plot(data,xlab=colnames(creditNum[i]))
}

#normalize
normalize<-function(x){
  return(x-min(x))/(std(x)-min(x))
}
credit_norm <- as.data.frame(lapply(creditNum, normalize))
credit_norm<-cbind(credit_norm,credit_data$card)
names(credit_norm)[names(credit_norm)=='credit_data$card']<-'card'

#modelling
model<-glm(formula = card ~ reports + expenditure + dependents + active, 
           family = "binomial", data = credit_norm)
summary(model)

car::vif(model)
MASS::stepAIC(model)


#confusion matrix table
prob<-predict(model,credit_norm,type="response")
prob

##confusion matrix
conf<-table(prob>0.5,credit_norm$card)
conf

##accuracy
acc<-sum(diag(conf)/sum(conf))
acc

##ROC
library(ROCR)
rocrpred<-prediction(prob,credit_data$card)
rocrperf<-performance(rocrpred,'tpr','fpr')
plot(rocrperf,colorize=T,text.adj=c(-0.2,1.7))
