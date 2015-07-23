## Title: plot4.R
## Author: Tjeerd Luykx
## Date: July 22nd 2015
## Description: create plot question 4.

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

# Question 4: across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Merge the two datasets
NEISCC <- full_join(NEI, SCC, by="SCC")

# Assign value to match and filter dataset
Coal <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)
NEISCC.f <- filter(NEISCC,Coal)

# Aggregate Emmissions per year
TotEmfromCoal <- aggregate(Emissions ~ year, NEISCC.f, FUN = sum)
colnames(TotEmfromCoal) <- c("Year","Emissions")

# Create ggplot barplot
png("plot4.png")
gPlot <- ggplot(TotEmfromCoal, aes(factor(Year), Emissions))
gPlot <- gPlot + geom_bar(stat="identity",fill="black", colour="blue") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle("U.S. Total PM'[2.5]*'Emissions from coal sources: 1999 to 2008")
print(gPlot)
dev.off()

# Answer: in total emissions have decreased from 1999 to 2008 with a small increase from 2002 to 2005.