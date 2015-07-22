## Title: plot1.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 1

library(ggplot2)

FileName <- "exdata-data-NEI_data.zip"

# Downloading and unzipping dataset:
if (!file.exists(FileName)){
        FileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileURL, FileName, method="curl")
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

# Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.

TotEmpYear <- data.frame(aggregate(Emissions ~ year, NEI, sum))
colnames(TotEmpYear) <- c("Year","Emissions")

png('plot1.png')
gPlot <- ggplot(data=TotEmpYear, aes(x=Year,y=Emissions)) +
                geom_bar(colour="black", fill="#DD8888", width=.8, stat="identity") +
                guides(fill=FALSE) +
                xlab("Years") + ylab("Total PM'[2.5]*' Emission") +
                ggtitle("Total PM'[2.5]*' Emissions from 1999 to 2008")

