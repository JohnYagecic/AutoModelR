# Translation of the hydrodynamic model automation files into R.
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/AutoModelR")

# Below are components of NOAA PORTS API search string
# see http://co-ops.nos.noaa.gov/api/

url1<-"http://tidesandcurrents.noaa.gov/api/datagetter?begin_date="
url2<-"&end_date="
url3<-"&station="
url4<-"&product="
url5<-"&interval=h&datum=MLLW&units=metric&time_zone=lst_ldt&application=DRBC&format=csv"

for (yyy in 1:2){ # Loop for locations
 if (yyy==1){
  PORTS.Station="8557380" # Lewes, DE see http://co-ops.nos.noaa.gov/stationhome.html?id=8557380
  PORTS.name="Lewes"
 }
 if(yyy==2){
  PORTS.Station="8573927" # Chesapeake City, MD C&D Canal see http://co-ops.nos.noaa.gov/stationhome.html?id=8573927
  PORTS.name="CandD"
 }
  EndDate=format(Sys.Date()+15, "%Y%m%d") # Establishing search date range based on 
  NowDate=format(Sys.Date(), "%Y%m%d")    #  code execution date.
  BeginDate=format(Sys.Date()-14, "%Y%m%d")
 
 
  print(BeginDate)
  print(NowDate)
  print(EndDate)
  
 for (jjj in 1:2){ # Loop for Predicted vs. Observed water surface elevations 1=predicted, 2=observed
  if (jjj==1){
    Product="predictions"
  }
  if (jjj==2){
    Product="water_level"
  }
  fileURL<-paste0(url1, BeginDate, url2, EndDate, url3, PORTS.Station, url4, Product, url5)
  myfilename=paste0(PORTS.name, Product, ".txt")
  download.file(fileURL, destfile=myfilename)
  
 }
  
}


