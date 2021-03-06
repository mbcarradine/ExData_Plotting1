##Unzip the file
unzip("projectdata.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

##load into table
pdata <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

##Format date to Type Date
pdata$Date <- as.Date(pdata$Date, "%d/%m/%Y")

##Filter data set to relevant dates
pdata <- subset(pdata,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

##Remove incomplete observation
pdata <- pdata[complete.cases(pdata),]

##Combine Date and Time column
dateTime <- paste(pdata$Date, pdata$Time)

##Name the vector
dateTime <- setNames(dateTime, "DateTime")

##Remove Date and Time column
pdata <- pdata[ ,!(names(pdata) %in% c("Date","Time"))]

## Add DateTime column
pdata <- cbind(dateTime, pdata)

## Format dateTime Column
pdata$dateTime <- as.POSIXct(dateTime)


##Making plot 4
## Create two rows + two columns and set margins
par(mfrow=c(2,2), mar=c(4,4,2,1))
# Create plots from pdata
with(pdata, {
        plot(Global_active_power~dateTime, type="l", 
             ylab="Global Active Power", xlab="")
        plot(Voltage~dateTime, type="l", 
             ylab="Voltage", xlab="datetime")
        plot(Sub_metering_1~dateTime, type="l", 
             ylab="Energy sub metering", xlab="")
        lines(Sub_metering_2~dateTime,col='red')
        lines(Sub_metering_3~dateTime,col='blue')
        legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(Global_reactive_power~dateTime, type="l", 
             ylab="Global Reactive Power",xlab="datetime")
})

##Save to png format and close device
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()

