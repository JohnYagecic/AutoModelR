# Translation of the hydrodynamic model automation files into R.
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/AutoModelR")

require(XML)

for (j in 1:2){

  if (j==1){
    ahpsURL<-"http://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=tren4&output=tabular"
    outname<-"DelawareAHPS.csv"
  }
  if (j==2){
    ahpsURL<-"http://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=padp1&output=tabular"
    outname<-"SchuylkillAHPS.csv"
  }
  
  ahpsRAW<-readHTMLTable(ahpsURL)
  
  # Extract 2 tables that make up the AHPS forecast
  ahpsDF1<-data.frame(ahpsRAW[[2]])
  ahpsDF2<-data.frame(ahpsRAW[[3]])
  ahpsDF<-rbind(ahpsDF1, ahpsDF2)  # bind into 1 data frame
  
  # convert text into appropriate numerics and dates
  # this part coerces NA's due to a double header line and a 2 header set from the 2nd table
  ahpsDF$Date.Time<-strptime(ahpsDF[,1], format("%m/%d %H:%M"))
  ahpsDF$Stage<-as.numeric(gsub("ft", "", as.character(ahpsDF[,2])))
  ahpsDF$Flow<-as.numeric(gsub("kcfs", "", as.character(ahpsDF[,3])))*1000
  
  # get rid of the orginal character fields and the coerced NA's
  ahpsDF<-ahpsDF[,4:6]
  ahpsDF
  ahpsDF<-na.omit(ahpsDF)
  
  write.table(ahpsDF, file=outname, sep=",", row.names=FALSE)

}


