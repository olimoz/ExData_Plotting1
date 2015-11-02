#Download and unzip data
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile="./exdata-data-household_power_consumption.zip")
unzip("./exdata-data-household_power_consumption.zip")

#Read data
powerdat<- read.table("household_power_consumption.txt", sep=";", header=T,na.strings = "?")

##Change date format
library(lubridate)
powerdat$Date<-dmy(powerdat$Date)

##Subset data to Feb 1st and 2nd 2007 only
chartdata<-powerdat[powerdat$Date>=ymd("2007-02-01") & powerdat$Date<=ymd("2007-02-02"),]

##Create a new datetime column, will be useful for plotting
chartdata$Datetime<-ymd_hms(paste(chartdata$Date,chartdata$Time))

##Convert other columns from Factor to numeric
for(i in 3:8){
  chartdata[,i]<-as.numeric(chartdata[,i])
}

#Start Plotting

#Function for Quadrant1
DoQuadrant1<-function(){
  plot(chartdata$Datetime, 
       chartdata$Global_active_power, 
       ylab = "Global Active Power (kilowatts)",
       xlab="",
       type="n"
  )
  lines(chartdata$Datetime, 
        chartdata$Global_active_power, 
        type="l") 
}

#Function for Quadrant2
DoQuadrant2<-function(){
  plot(chartdata$Datetime, 
       chartdata$Voltage, 
       ylab = "Voltage",
       xlab="datetime",
       type="n"
  )
  lines(chartdata$Datetime, 
        chartdata$Voltage, 
        type="l"
  )
}

#Function for Quadrant3
DoQuadrant3<-function(){
  
  plot(chartdata$Datetime, 
       chartdata$Sub_metering_1, 
       ylab = "Energy sub metering",
       xlab = "",
       type = "n"
  )
  lines(chartdata$Datetime, 
        chartdata$Sub_metering_1, 
        type="l",
        col = "black"
  )
  lines(chartdata$Datetime, 
        chartdata$Sub_metering_2, 
        type="l",
        col = "red"
  )
  lines(chartdata$Datetime, 
        chartdata$Sub_metering_3, 
        type="l",
        col = "blue"
  )
  legend("topright", 
         lty = 1,
         col = c("black","red","blue"),
         legend = c("Sub_metering_1", 
                    "Sub_metering_2",
                    "Sub_metering_3"
         )
  )
}

#Function for Quadrant4
DoQuadrant4<-function(){
  plot(chartdata$Datetime, 
       chartdata$Global_reactive_power, 
       xlab="datetime",
       ylab="Global_reactive_power",
       type="n"
  )
  lines(chartdata$Datetime, 
        chartdata$Global_reactive_power, 
        type="l"
  )
}

#plot4.png
png(file = "plot4.png", bg = "white")

##set out quadrants
par(mfrow = c(2, 2)) 

##Plot Quadrants
DoQuadrant1()
DoQuadrant2()
DoQuadrant3()
DoQuadrant4()

dev.off()