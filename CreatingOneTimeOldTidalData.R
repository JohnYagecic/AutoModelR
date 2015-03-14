# This script documents how I made the OldTidalData.csv file
# since this theoretically is only developed once (and updated by the automated
# processing system) this is not strictly automated.  Some actions are performed
# manually outside of the R framework, and are notated as such.

# run the AMRCreateTideTextFile.R function

TextTide(20140806, 20150314, 8557380) # create full 6-minute Lewes for last 200 days
# after execution, manually change name of output file from tides.csv to oldLewes6m.csv

TextTide(20140806, 20150314, 8573927) # same process for C&D canal
# after execution, manually change output file name to oldCandD6m.csv

oldLewes<-read.csv("oldLewes6m.csv")


require(lubridate)
oldLewes$minute<-minute(oldLewes[,1]) # add column extracting minute
head(oldLewes, 20)
oldLewesH<-oldLewes[oldLewes$minute==0, 1:2] # create new df of hourly only data
head(oldLewesH, 20)
names(oldLewesH)<-c("Date.Time", "Lewes.MLLW")

oldCandD<-read.csv("oldCandD6m.csv")
oldCandD<-oldCandD[,1:2]
names(oldCandD)<-c("Date.Time", "CandD.MLLW")

OldTidalData<-merge(oldLewesH, oldCandD, by.x="Date.Time", by.y="Date.Time", all.x=T)

head(OldTidalData)

# Add columns with WSE converted to NGVD
LewesToNGVD=0.569
CandDToNGVD=0.236

OldTidalData$Lewes.NGVD<-OldTidalData$Lewes.MLLW-LewesToNGVD
OldTidalData$CandD.NGVD<-OldTidalData$CandD.MLLW-CandDToNGVD

head(OldTidalData, 20)

write.table(OldTidalData, file="OldTidalData.csv", sep=",", row.names=FALSE)