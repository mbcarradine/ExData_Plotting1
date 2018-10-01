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

## Make the plot
hist(pdata$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")

##Save to png format and close device
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()