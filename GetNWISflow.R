# Translation of the hydrodynamic model automation files into R.
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com

#  This script downloads daily discharge data from the USGS NWIS system and copies .csv files to the
#  working directory.

setwd("~/AutoModelR")

require(dataRetrieval) # USGS library for accessing NWIS data

for (jjj in 1:2){
  
  EndDate=format(Sys.Date(), "%Y-%m-%d") # Establishing search date range based on  
  BeginDate=format(Sys.Date()-200, "%Y-%m-%d") # Start query to retrieve the previous 200 days of data
  
  if(jjj==1){
    siteNo<-"01463500"
    outname<-"Discharge_Delaware_Trenton.csv"
    lastQ<-11656 # Mean Daily Flow - will only be used if first record retrieved is NA
  }
  if (jjj==2){
    siteNo<-"01474500"
    outname<-"Discharge_Schuylkill_Philadelphia.csv"
    lastQ<-2730 # Mean Daily Flow - will only be used if first record retrieved is NA
  }
  
  Param<-"00060"  # Parameter code for discharge CFS
  Discharge<-readNWISdv(siteNo, Param, BeginDate, EndDate)
  
  names(Discharge)<-c("Agency", "Station", "Date", "Flag", "Discharge.CFS")
  
  # below replaces NA discharge with most recent quantified
  # if first record is NA, uses central tendancy value from above
  for (iii in 1:nrow(Discharge)){
    if (is.na(Discharge[iii,5])==FALSE){
      lastQ<-Discharge[iii,5]
    }
    if (is.na(Discharge[iii,5])==TRUE){
      Discharge[iii,5]<-lastQ
      Discharge[iii,4]<-"Replaced NA"
    }
  }
  write.table(Discharge, file=outname, sep=",", row.names=FALSE)
  Discharge
  
}

