setwd("~/AutoModelR")

myToday<-as.character(format(Sys.Date(), "%m/%d/%Y"))

for (jjj in 1:2){
   # Two loops through, first for Delaware, second for Schuylkill
  if (jjj==1){
    NWISfile="Discharge_Delaware_Trenton.csv"
    AHPSfile="DelawareAHPS.csv"
    PNGout="DelawareNonTidal.png"
    PlotTitle="Delaware at Trenton, Observed and Forecasted Discharge"
  }
  
  if (jjj==2){
    NWISfile="Discharge_Schuylkill_Philadelphia.csv"
    AHPSfile="SchuylkillAHPS.csv"
    PNGout="SchuylkillNonTidal.png"
    PlotTitle="Schuylkill at Philadelphia, Observed and Forecasted Discharge"
  }

  RivQ<-read.csv(NWISfile)                  # NWIS flows are provided by Date only, need time
  RivQ$Date<-paste0(RivQ$Date, " 00:00:01") # Add one second to force retention of POSIX class
  
  RivQ$Date<-strptime(RivQ$Date, format("%Y-%m-%d %H:%M:%S"))
  
  RivAHPS<-read.csv(AHPSfile)
  RivAHPS$Date.Time<-strptime(RivAHPS$Date.Time, format("%Y-%m-%d %H:%M:%S"))
  
  # Lines below separate NWIS data into observations and extrapolations of last value
  # for NA data (such as ice or meter malfunction)
  RivObs<-RivQ[(as.Date(RivQ$Date)>(Sys.Date()-20)&RivQ$Flag!="Replaced NA"),]
  RivAll<-RivObs[,c(3,5)] # RivAll is needed to plot continuous black line in plot
  
  RivNA<-RivQ[(as.Date(RivQ$Date)>(Sys.Date()-20)&RivQ$Flag=="Replaced NA"),]
  RivAll<-rbind(RivAll, RivNA[,c(3,5)])
  names(RivAll)<-c("Date", "Discharge")
  
  lastDate<-max(RivQ$Date) # mark last NWIS value
  RivAHPStemp<-RivAHPS[(RivAHPS$Date.Time>lastDate),c(1,3)] # cut off AHPS older than most recent NWIS
  RivAHPStemp$Flag<-"AHPS"
  names(RivAHPStemp)<-c("Date", "Discharge", "Flag")
  RivAll<-rbind(RivAll, RivAHPStemp[,1:2]) # 
  RivAll<-RivAll[order(RivAll$Date),]
  
  PlotTitle=paste0(PlotTitle, "\nData Retrieved ", myToday) # add generation date to plot title
  
  png(file=PNGout)
  plot(RivAll$Date, RivAll$Discharge, col="black", type="l",
       xlim=c(Sys.time()-(20*24*60*60), Sys.time()+(5*24*60*60)),
       xlab="Date & Time", ylab="Discharge (CFS)",
       main=PlotTitle) # black line from RivAll
  points(RivObs$Date, RivObs$Discharge.CFS, col="blue", pch=19) # color points and legend from
  points(RivNA$Date, RivNA$Discharge.CFS, col="red", pch=19)    # subsets
  points(RivAHPStemp$Date, RivAHPStemp$Discharge, col="green", pch=19)
  legend("topleft", legend=c("Obs", "NA", "AHPS"), col=c("blue", "red", "green"), pch=19)
  dev.off()
 
}
