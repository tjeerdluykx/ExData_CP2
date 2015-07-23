## Title: plot6.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 6.

library(dplyr)
library(ggplot2)

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

# Question 6: compare emissions from motor vehicle sources in Baltimore City with emissions from
# motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# Merge the two data sets
NEISCC <- full_join(NEI, SCC, by = "SCC")

# Filter large dataset
NEISCC.f <- filter(NEISCC, fips == "24510" | fips == "06037" & type == "ON-ROAD")

# Aggregate emissions
LABaEmMotor <- aggregate(Emissions ~ year + fips, NEISCC.f, FUN = sum)
LABaEmMotor$fips[LABaEmMotor$fips=="24510"] <- "Baltimore"
LABaEmMotor$fips[LABaEmMotor$fips=="06037"] <- "Los Angeles"
colnames(LABaEmMotor) <- c("Year","City","Emissions")

# Create facet grid barplot
png("plot6.png")
gPlot <- ggplot(LABaEmMotor, aes(factor(Year), Emissions))
gPlot <- gPlot + facet_grid(. ~ City)
gPlot <- gPlot + geom_bar(stat="identity",fill="black", colour="blue") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle("Baltimore vs Los Angeles Total PM'[2.5]*'Emissions from motor vehicles: 1999 to 2008")
print(gPlot)
dev.off()

# Answer: Baltimore.