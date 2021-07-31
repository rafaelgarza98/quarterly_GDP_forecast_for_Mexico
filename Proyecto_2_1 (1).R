rm(list = ls()) #Clear memory

library(heatmaply)
library(readxl)
library(aTSA)
library(astsa)
library(ggcorrplot)
library(xts)
library(dplyr)
library(GGally)
library(forecast)
library(car)

data <- read_excel("C:/Users/rafae/Downloads/Base_datos_GDP.xlsx")

#PIB
Y <- data.matrix(data[2:NROW(data),2])
pp.test(Y)

#Industria
X1 <- data.matrix(data[2:NROW(data),3])
pp.test(X1)

#Energia
X2 <- data.matrix(log(data[1:NROW(data),4])); X2 <- data.matrix(diff(X2)*100)
pp.test(X2)

#Importacion
X3 <- data.matrix(data[2:NROW(data),5])
pp.test(X3)

#WTI
X4 <- data.matrix(data[2:NROW(data),6])
pp.test(X4)
data <- data.frame(Y,X1,X2,X3,X4)
X <- data.matrix(cbind(X1,X2,X3,X4))

for(i in 1:4){
  if (i==1){   
    lag_industria<-cbind(X[,1],lag.xts(X[,1],k=i))
  } else {
    lag_industria <-cbind(lag_industria,lag.xts(X[,1],k=i))
  }
}

PIB_Indus <- data.frame(Y,lag_industria)
ggcorrplot(cor(PIB_Indus[5:NROW(PIB_Indus),]),lab=T)
#Contemporanea

for(i in 1:4){
  if (i==1){   
    lag_energia<-cbind(X[,2],lag.xts(X[,2],k=i))
  } else {
    lag_energia <-cbind(lag_energia,lag.xts(X[,2],k=i))
  }
}

PIB_energia <- data.frame(Y,lag_energia)
ggcorrplot(cor(PIB_energia[5:NROW(PIB_energia),]),lab=T)
#Contemporanea

for(i in 1:4){
  if (i==1){   
    lag_importa<-cbind(X[,3],lag.xts(X[,3],k=i))
  } else {
    lag_importa <-cbind(lag_importa,lag.xts(X[,3],k=i))
  }
}

PIB_importa <- data.frame(Y,lag_importa)
ggcorrplot(cor(PIB_importa[5:NROW(PIB_importa),]),lab=T)
#Contemporanea

for(i in 1:4){
  if (i==1){   
    lag_WIT<-cbind(X[,4],lag.xts(X[,4],k=i))
  } else {
    lag_WIT <-cbind(lag_WIT,lag.xts(X[,4],k=i))
  }
}

PIB_WIT <- data.frame(Y,lag_WIT)
ggcorrplot(cor(PIB_WIT[5:NROW(PIB_WIT),]),lab=T)
#Contemporanea

#Act industrial lag=0
X1<-lag_industria[,1]

#Energia  lag=0
X2<-lag_energia[,1]

#Importacion  lag=0
X3<-lag_importa[,1]

#WIT lag=0
X4<-lag_WIT[,1]

data <- data.frame(Y,X1,X2,X3,X4)
X <- data.matrix(cbind(X1,X2,X3,X4))

#Prueba de colinealidad entre las variables
cor(X)
Z1 <- data.matrix(data[5:NROW(data),2])
Z2 <- data.matrix(data[5:NROW(data),3])
Z3 <- data.matrix(data[5:NROW(data),4])
Z4 <- data.matrix(data[5:NROW(data),5])

m2 <- lm(Y[5:NROW(Y),]~Z1+Z2+Z3+Z4)
vif(m2)
#No esta presente el problema de colinealidad entre las variables

Xreg <- X[(5:NROW(X)),]
m1 <- lm(Y[5:NROW(Y),]~ Xreg)
acf2(residuals(m1))

Y2 <- sarima(Y[5:NROW(Y),],6,0,0, fixed=c(0,0,0,0,0,NA,NA,NA,NA,NA,NA), xreg=Xreg)
acf2(Y2[["fit"]][["residuals"]])


#Pronostico Industria
acf2(X[,1])
X_IN<-sarima(Xreg[,1],1,0,0)
residualesX_IN<-X_IN[["fit"]][["residuals"]]
acf2(residualesX_IN)

#Pronostico Energia
acf2(X[,2])
X_energia<-sarima(Xreg[,2],12,0,0, fixed=c(0,0,0,0,0,0,0,0,0,0,0,NA,NA))
residualesX_energia<-X_energia[["fit"]][["residuals"]]
acf2(residualesX_energia)

#Pronostico Importaciones
acf2(X[,3])
X_importa<-sarima(Xreg[,3],1,0,0)
residualesX_importa<-X_importa[["fit"]][["residuals"]]
acf2(residualesX_importa)

#Pronostico WIT
acf2(X[,4])
X_WTI<-sarima(Xreg[,4],0,0,0)
residualesX_WTI<-X_WTI[["fit"]][["residuals"]]
acf2(residualesX_WTI)

#Pronostico

X_in<-sarima.for(Xreg[,1],1,0,0, n.ahead=1)
in_pred<-as.data.frame(X_in$pred)

X_ene<-sarima.for(Xreg[,2],12,0,0, fixed=c(0,0,0,0,0,0,0,0,0,0,0,NA,NA), n.ahead=1)
ene_pred<-as.data.frame(X_ene$pred)

X_impo<-sarima.for(Xreg[,3],1,0,0, n.ahead=1)
impo_pred<-as.data.frame(X_impo$pred)

X_wti<-sarima.for(Xreg[,4],0,0,0, n.ahead=1)
wti_pred<-as.data.frame(X_wti$pred)

Xpron <- data.matrix(cbind(in_pred,ene_pred,impo_pred,wti_pred))
Ypron<-sarima.for(Y[5:NROW(Y),],6,0,0, fixed=c(0,0,0,0,0,NA,NA,NA,NA,NA,NA), xreg=Xreg, newxreg=Xpron,n.ahead=1)


#Prueba de estrés
e=c(); e_bm=c();

for (t in 120:NROW(data)) {
  Y2<-sarima(data[5:(t-1),1],6,0,0, fixed=c(0,0,0,0,0,NA,NA,NA,NA,NA,NA), xreg=data[5:(t-1),2:5],n.ahead=1)
  
  X_IN<-sarima.for(Xreg[,1],1,0,0, n.ahead=1)
  IN_pred<-as.data.frame(X_IN$pred)
  
  X_energia<-sarima.for(Xreg[,2],12,0,0, fixed=c(0,0,0,0,0,0,0,0,0,0,0,NA,NA), n.ahead=1)
  energia_pred<-as.data.frame(X_energia$pred)
  
  X_importa<-sarima.for(Xreg[,3],1,0,0, n.ahead=1)
  importa_pred<-as.data.frame(X_importa$pred)
  
  X_WTI<-sarima.for(Xreg[,4],0,0,0, n.ahead=1)
  WTI_pred<-as.data.frame(X_WTI$pred)
  
  Xpred <- data.matrix(cbind(IN_pred,energia_pred,importa_pred,WTI_pred))
  Yfor<-sarima.for(Y[5:(t-1),1],6,0,0, fixed=c(0,0,0,0,0,NA,NA,NA,NA,NA,NA), xreg=data[5:(t-1),2:5], newxreg=Xpred,n.ahead=1)
  
  error<-(as.numeric(data[t,1])-as.numeric(Yfor[["pred"]]))^2
  e<-c(e,error)
  
  a <- auto.arima(data[5:(t-1),1])
  f <- forecast(a,h=1)
  
  error<-(as.matrix(data[t,1])-as.matrix(f$mean))^2
  e_bm<-c(e_bm,error)
}

mse<-cbind(e,e_bm)
colnames(mse) <-c("ARMAX","ARIMA") 
colMeans(mse)












