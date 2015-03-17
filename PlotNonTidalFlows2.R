setwd("~/AutoModelR")

DelQ<-read.csv("Discharge_Delaware_Trenton.csv")
DelQ$Date<-paste0(DelQ$Date, " 0:0:0")
DelQ$Date<-as.Date(DelQ$Date, format="%Y-%m-%d %H:%M:%S")

head(DelQ)

DelAHPS<-read.csv("DelawareAHPS.csv")
DelAHPS$Date.Time<-as.Date(DelAHPS$Date.Time, format="%Y-%m-%d %H:%M:%S")

DelObs<-DelQ[(DelQ$Date>(Sys.Date()-20)&DelQ$Flag!="Replaced NA"),]
head(DelObs)
DelAll<-DelObs[,c(3,5)]

DelNA<-DelQ[(DelQ$Date>(Sys.Date()-20)&DelQ$Flag=="Replaced NA"),]
head(DelNA)
DelAll<-rbind(DelAll, DelNA[,c(3,5)])
names(DelAll)<-c("Date", "Discharge")

lastDate<-max(DelQ$Date)
DelAHPStemp<-DelAHPS[(DelAHPS$Date.Time>lastDate),c(1,3)]
DelAHPStemp$Flag<-"AHPS"
names(DelAHPStemp)<-c("Date", "Discharge", "Flag")
head(DelAHPStemp)
DelAll<-rbind(DelAll, DelAHPStemp[,1:2])
DelAll<-DelAll[order(DelAll$Date),]

png(file="DelawareNonTidal.png")
plot(DelAll$Date, DelAll$Discharge, col="black", type="l",
     xlim=c(Sys.Date()-20, Sys.Date()+5),
     xlab="Date & Time", ylab="Discharge (CFS)",
     main="Delaware at Trenton, Observed and Forecasted Discharge")
points(DelObs$Date, DelObs$Discharge.CFS, col="blue", pch=19)
points(DelNA$Date, DelNA$Discharge.CFS, col="red", pch=19)
points(DelAHPStemp$Date, DelAHPStemp$Discharge, col="green", pch=19)
legend("topleft", legend=c("Obs", "NA", "AHPS"), col=c("blue", "red", "green"), pch=19)
dev.off()

#  Schuylkill River

SchQ<-read.csv("Discharge_Schuylkill_Philadelphia.csv")
SchQ$Date<-paste0(SchQ$Date, " 0:0:0")
SchQ$Date<-as.Date(SchQ$Date, format="%Y-%m-%d %H:%M:%S")

SchAHPS<-read.csv("SchuylkillAHPS.csv")
SchAHPS$Date.Time<-as.Date(SchAHPS$Date.Time, format="%Y-%m-%d %H:%M:%S")

SchObs<-SchQ[(SchQ$Date>(Sys.Date()-20)&SchQ$Flag!="Replaced NA"),]
SchAll<-SchObs[,c(3,5)]

SchNA<-SchQ[(SchQ$Date>(Sys.Date()-20)&SchQ$Flag=="Replaced NA"),]
SchAll<-rbind(SchAll, SchNA[,c(3,5)])
names(SchAll)<-c("Date", "Discharge")

lastDate<-max(SchQ$Date)
SchAHPStemp<-SchAHPS[(SchAHPS$Date.Time>lastDate),c(1,3)]
SchAHPStemp$Flag<-"AHPS"
names(SchAHPStemp)<-c("Date", "Discharge", "Flag")
SchAll<-rbind(SchAll, SchAHPStemp[,1:2])
SchAll<-SchAll[order(SchAll$Date),]

png(file="SchuylkillNonTidal.png")
plot(SchAll$Date, SchAll$Discharge, col="black", type="l",
     xlim=c(Sys.Date()-20, Sys.Date()+5),
     pch=19, xlab="Date & Time", ylab="Discharge (CFS)",
     main="Schuylkill at Philadelphia, Observed and Forecasted Discharge")
points(SchObs$Date, SchObs$Discharge.CFS, col="blue", pch=19)
points(SchNA$Date, SchNA$Discharge.CFS, col="red", pch=19)
points(SchAHPStemp$Date, SchAHPStemp$Discharge, col="green", pch=19)
legend("topleft", legend=c("Obs", "NA", "AHPS"), col=c("blue", "red", "green"), pch=19)
dev.off()

