# Translation of the hydrodynamic model automation files into R.
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/AutoModelR")
myToday<-as.character(format(Sys.Date(), "%m/%d/%Y"))

# Raw predictions are hourly, so use these as the basis of an hourly data frame
# LPR for Lewes Predicted Raw
LPR<-read.csv("Lewespredictions_RAW.csv")
LPR$Date.Time<-strptime(LPR$Date.Time, format("%Y-%m-%d %H:%M"))
names(LPR)<-c("GMT","LPR")
LPR$LPRnumdat<-as.numeric(LPR$GMT)

# CPR for C&D Canal Predicted Raw
CPR<-read.csv("CandDpredictions_RAW.csv")
CPR$Date.Time<-strptime(CPR$Date.Time, format("%Y-%m-%d %H:%M"))
names(CPR)<-c("GMT","CPR")
CPR$CPRnumdat<-as.numeric(CPR$GMT)

# LOR is Lewes Observed water surface Raw
LOR<-read.csv("Leweswater_level_RAW.csv")
LOR$Date.Time<-strptime(LOR$Date.Time, format("%Y-%m-%d %H:%M"))
# Limit to date and level columns for clarity
LOR<-LOR[,1:2]
names(LOR)<-c("GMT","LOR")
LOR$LORnumdat<-as.numeric(LOR$GMT)
LastLORnum<-LOR$LORnumdat[nrow(LOR)]  # note numeric date-time of last observation

# COR is C&D Canal Observed water surface Raw
COR<-read.csv("CandDwater_level_RAW.csv")
COR$Date.Time<-strptime(COR$Date.Time, format("%Y-%m-%d %H:%M"))
# Limit to date and level columns for clarity
COR<-COR[,1:2]
names(COR)<-c("GMT","COR")
COR$CORnumdat<-as.numeric(COR$GMT)
LastCORnum<-COR$CORnumdat[nrow(COR)] # note numeric date-time of last observation


head(LOR)
head(COR)

head(LPR)
head(CPR)

AllTidalData<-merge(LPR, CPR, by.x="LPRnumdat", by.y="CPRnumdat", all.x=T)
AllTidalData<-AllTidalData[,-4] # get rid of extra GMT column

AllTidalData<-merge(AllTidalData, LOR, by.x="LPRnumdat", by.y="LORnumdat", all.x=T)
AllTidalData<-AllTidalData[,-5] # get rid of extra GMT column
head(AllTidalData)

AllTidalData<-merge(AllTidalData, COR, by.x="LPRnumdat", by.y="CORnumdat", all.x=T)
AllTidalData<-AllTidalData[,-6] # get rid of extra GMT column
head(AllTidalData)

# Below eliminates rows with NA in first column.  This is needed to address ambiguity during 
# transitions between EST and EDT
AllTidalData<-AllTidalData[complete.cases(AllTidalData[,1]),]

# Plot MLLW time series to working directory
png(file="LewesWSE.png")
plot(AllTidalData$GMT.x, AllTidalData$LPR, type="l", xlab="Date (GMT)", col="blue",
     ylab="WSE Meters (MLLW)",
     main=paste0("Water Surface Elevations at Lewes, DE\nData Retrieved ", myToday))
points(AllTidalData$GMT.x, AllTidalData$LOR, type="l", col="red")
legend("topleft", c("Predicted", "Observed"), col=c("blue", "red"), lty=c(1,1))
dev.off()

png(file="CandDWSE.png")
plot(AllTidalData$GMT.x, AllTidalData$CPR, type="l", xlab="Date (GMT)", col="blue",
     ylab="WSE Meters (MLLW)",
     main=paste0("Water Surface Elevations at C&D Canal\nData Retrieved ", myToday))
points(AllTidalData$GMT.x, AllTidalData$COR, type="l", col="red")
legend("topleft", c("Predicted", "Observed"), col=c("blue", "red"), lty=c(1,1))
dev.off()



# Within observation range, replace missing data with predictions
for (i in 1:nrow(AllTidalData)){
  if (is.na(AllTidalData[i,5]) & (AllTidalData[i,1] < LastLORnum)){
    AllTidalData[i,5]<-AllTidalData[i,3]
  }
  if (is.na(AllTidalData[i,6]) & (AllTidalData[i,1] < LastCORnum)){
    AllTidalData[i,6]<-AllTidalData[i,4]
  }
}

# Add columns with WSE converted to NGVD
LewesToNGVD=0.569
CandDToNGVD=0.236

AllTidalData$LPNGVD<-AllTidalData$LPR-LewesToNGVD
AllTidalData$LONGVD<-AllTidalData$LOR-LewesToNGVD
AllTidalData$CPNGVD<-AllTidalData$CPR-CandDToNGVD
AllTidalData$CONGVD<-AllTidalData$COR-CandDToNGVD

AllTidalData

write.table(AllTidalData, file="AllTidalData.csv", sep=",", row.names=FALSE)


