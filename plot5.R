## Title: plot5.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 5.

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

# Question 5: how have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Merge the two data sets
NEISCC <- full_join(NEI, SCC, by="SCC")

# Filter large dataset
NEISCC.f <- filter(NEISCC, fips == "24510" & type == "ON-ROAD")

# Aggregate emissions
BalEmMotor <- aggregate(Emissions ~ year, NEISCC.f, FUN = sum)
colnames(BalEmMotor) <- c("Year","Emissions")

# Create barplot
png("plot5.png")
gPlot <- ggplot(BalEmMotor, aes(factor(Year), Emissions))
gPlot <- gPlot + geom_bar(stat="identity",fill="black", colour="blue") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle("Baltimore Total PM'[2.5]*'Emissions from motor vehicles: 1999 to 2008")
print(gPlot)
dev.off()

# Answer: emissions from motor vehicles have significantly decreased in Baltimore City from 1999 to 2008.