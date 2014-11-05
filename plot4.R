# Unzip, load and prepare data
unzip("exdata%2Fdata%2Fhousehold_power_consumption.zip")
data_file <- "household_power_consumption.txt"

# Read first row to get start datetime, column classes, column names
first_row <- read.table(data_file, header = TRUE,
                        sep = ";", na.strings = "?", stringsAsFactors = FALSE,
                        nrows = 1)
attach(first_row)

# Save column names for later
column_names <- colnames(first_row)

# First datetime in file; there's one row for each minute
file_start_datetime <- strptime(paste(Date, Time, sep = " "),
                                format = "%d/%m/%Y %H:%M:%S")

# Column classes
classes <- sapply(first_row, class)

# Start and end datetimes for the range of interest
start_datetime <- strptime("2007-02-01 00:00:00", format = "%Y-%m-%d %H:%M:%S")
end_datetime <- strptime("2007-02-02 23:59:00", format = "%Y-%m-%d %H:%M:%S")

# Determine the number of rows to skip and the number to read
skips <- difftime(start_datetime, file_start_datetime, units = "mins")
reads <- difftime(end_datetime, start_datetime, units = "mins")+1

# Use colClasses, skip and nrows to load data quickly
data <- read.table(data_file, header = TRUE,
                   sep = ";", na.strings = "?",
                   colClasses = classes,
                   skip = skips,
                   nrows = reads)

# Recover column names
colnames(data) <- column_names
datetime <- strptime(paste(data$Date, data$Time, sep = " "),
                     format = "%d/%m/%Y %H:%M:%S")
weekday <- weekdays(datetime)
newdata <- cbind(data,datetime,weekday)
attach(newdata)

#Plot the data
png("plot4.png",width=480,height=480)
par(mfrow=c(2,2))
xmax=length(newdata$Date)

#Top left graph
plot(x=datetime, y=Global_active_power, type="l",
     ylab="Global Active Power (kilowatts)",
     xlab="",
     main=""
)
box("plot")

#Top right graph
plot(x=datetime, y=Voltage, type='l',
     ylab="Voltage",
     xlab="datetime",
     main=""
)
box("plot")

#Bottom left graph
plot(datetime, Sub_metering_1, type = "l",
     ylab="Energy sub metering",
     xlab=""
)
lines(x=datetime, y=data$Sub_metering_2, type = "l", col="red")
lines(x=datetime, y=data$Sub_metering_3, type = "l", col="blue")
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,  
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
box("plot")

#Bottom right graph
plot(x=datetime, y=Global_reactive_power, type='l',
     ylab="Global_reactive_power",
     xlab="datetime")
box("plot")
dev.off()