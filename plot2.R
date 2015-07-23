## Title: plot2.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 2.

library(dplyr)

FileName <- "exdata-data-NEI_data.zip"

# Downloading and unzipping dataset:
if (!file.exists(FileName)){
        FileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(FileURL, FileName, method="curl")
}  
if (!file.exists("exdata-data-NEI_data")) { 
        unzip(FileName) 
}

# Load data sets from home directory:
if(!exists("NEI")){
        NEI <- readRDS("./summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("./Source_Classification_Code.rds")
}

# Question 2: have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Use the base plotting system to make a plot answering this question.

# Filter data set
NEI.f <- filter(NEI,fips == "24510")

# Aggregate Emmissions per year
BalEmYear <- aggregate(Emissions ~ year, NEI.f, FUN = sum)
colnames(BalEmYear) <- c("Year","Emissions")

# Create barplot
png('plot2.png')
barplot(height = BalEmYear$Emissions,
        names.arg = BalEmYear$Year,
        xlab = "Years",
        ylab = expression('Baltimore City Total PM'[2.5]*' Emission'),
        col = c("blue","red","yellow","green"),
        main = expression('Total PM'[2.5]*' Emissions from 1999 to 2008 in Baltimore City'))
dev.off()

# Answer: as is visible in plot2 the PM2.5 emissions have decreased from 1999 to 2002 and decreased from to 2005 to 2008
# after an increase from 2002 to 2005. 
