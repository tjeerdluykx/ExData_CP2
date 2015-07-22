## Title: plot3.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 3.

library(dplyr)
library(ggplot2)

FileName <- "exdata-data-NEI_data.zip"

# Downloading and unzipping dataset:
if (!file.exists(FileName)){
        FileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(FileURL, FileName, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(FileName) 
}

# Load data sets from home directory:
if(!exists("NEI")){
        NEI <- readRDS("./summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("./Source_Classification_Code.rds")
}

# Question 3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

# Filter data set
NEI.f <- filter(NEI,fips == "24510")

# Aggregate Emmissions per year
BalEmYearType <- aggregate(Emissions ~ year + type, NEI.f, FUN = sum)
colnames(BalEmYearType) <- c("Year","Type","Emissions")

# Create ggplot graph
png("plot3.png")
gPlot <- ggplot(BalEmYearType, aes(Year, Emissions, color = Type))
gPlot <- gPlot + geom_line() +
        xlab("Year") +
        ylab(expression('Baltimore City Total PM'[2.5]*" Emissions")) +
        ggtitle("Total PM'[2.5]*'Emissions from 1999 to 2008 in Baltimore City")
print(gPlot)
dev.off()

# Answer: decreased(nonpoint, onroad, nonroad) and increased (point).
