setwd("~/AutoModelR")

TextTide<-function(date1, date2, station){
# A function to retrieve water level data from NOAA PORTS and write it to a text file in
# the working directory.
# Written by John Yagecic in 2014
#  JYagecic@gmail.com
#
# This version slightly edited to support AutoModelR project
#
# enter date as yyyymmdd
# station is a 7 digit number such as 8545240
# "8557380" is Lewes, DE
# "8573927" is Chesapeake City, MD C&D Canal 

sdate<-strptime(as.character(date1), "%Y%m%d")
finaldate<-strptime(as.character(date2), "%Y%m%d")
station<-as.character(station)

loopnum<-1

char1<-"http://tidesandcurrents.noaa.gov/api/datagetter?begin_date="
char2<-"&end_date="
char3<-"&station="
char4<-"&product=water_level&datum=MLLW&units=metric&time_zone=gmt&application=DRBC&format=csv"
# in char4, time_zone changed to gmt from original function
while (julian(sdate)<julian(finaldate)){ 
	edate<-as.Date(sdate)+30
	if (julian(edate)>julian(finaldate)){edate<-as.Date(finaldate)}
	BeginDate<-as.character(sdate,format="%Y%m%d")
	EndDate<-as.character(edate,format="%Y%m%d")
	fileURL<-paste0(char1, BeginDate, char2, EndDate, char3, station, char4)
	download.file(fileURL, destfile="temp.csv")
	
	if (loopnum==1){
		tides<-data.frame(read.csv("temp.csv"))
		write.table(tides, file = "tides.csv", sep = ",", row.names=FALSE)
		}
	else {
		TempCon=file("temp.csv", "r")
		newDat<-data.frame(read.csv(TempCon))
		close(TempCon)
		write.table(newDat, file = "tides.csv", sep = ",", 
            col.names = FALSE, row.names=FALSE, append=TRUE)
		}

	sdate<-as.Date(edate)+1
	loopnum<-loopnum+1			
}
}
