#
# Course 4 Week 1 Project, J. Flipse, 10 Feb 2018
#

# Source files:
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

td = getwd()                                    # Extract to working directory (td)
tf = tempfile(tmpdir=td, fileext=".zip")        # Create placeholder file
download.file(URL, tf)                          # Download ZIP file to td

library(plyr)
library(dplyr)
library(data.table)

# Get the zip files name & path (zipF), then unzip all to the working directory
zipF <- list.files(path = td, pattern = "*.zip", full.names = TRUE)
ldply(.data = zipF, .fun = unzip, exdir = td)

#
# The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory 
# the dataset will require in memory before reading into R. Make sure your computer has enough memory 
# (most modern computers should be fine).
#
numRows <- 2075259
numCols <- 9
neededMB <- round(numRows*numCols*8/2^{20},2)
# > neededMB
# [1] 142.5 MB required  ==> this is a low memory need, therefore no need to subset data into memory

######## Load Data ########
dtPower <- read.table(file.path(td, "household_power_consumption.txt"),sep = ";", header = TRUE)

# Restrict data bwtween 2007-02-01 to 2007-02-02 (src fmt: "16/12/2006")
dtPower$dt <- as.Date(dtPower$Date,"%d/%m/%Y")
date1 <- c("2007-02-01"); date2 <- c("2007-02-02")
dt2007 <- subset(dtPower, dt>=date1 & dt <=date2)
rm(dtPower)     # Free memory

# Form combined date (dt) + time (Time) for plotting to new column ts
dt2007$ts <- with(dt2007, as.POSIXct(paste(dt, Time), format="%Y-%m-%d %H:%M:%S"))

#
# Create line chart of days of week + time vs. Energy sub-metering ("Sub_metering_1", 
# "Sub_metering_2", and "Sub_metering_3")
#

# Create initial with submeetering 1...
plot(dt2007$ts, as.numeric(as.character(dt2007$Sub_metering_1)),type = "l",
     ylab = "Energy sub metering", xlab = "")
# Add submeetering 2 as a red line
lines(dt2007$ts, as.numeric(as.character(dt2007$Sub_metering_2)),type = "l", 
      col="red")
# Add submeetering 3 as a blue line
lines(dt2007$ts, as.numeric(as.character(dt2007$Sub_metering_3)),type = "l", 
      col="blue")
# Add a legend in the upper right corner
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                col = c("black", "red", "blue"), lty = c(1,1,1))

#
# Transfer to PNG file "plot3.png"
#
dev.copy(png, file = "plot3.png")

# Close the PNG device
dev.off()
