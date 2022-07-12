# ******************************************************************************
# R script to perform analysis on labour market data specified in ONS_URLs.R
# ******************************************************************************

# Imports ----

source("ONS_URLs.R")

# Web scrape relevant data ----

labourData <- list()
labourData <- csvDownload(labourURLs, labourData)

# Data name set ----

local_earnings <- labourData[[1]]

# Data cleaning ----

## Earnings data ----

names(local_earnings)[1] <- "AvgPay" # Amount in £

local_earnings <- local_earnings %>%
  filter(WorkplaceOrResidence == "Residence",
         WorkingPattern == "All",
         HoursAndEarnings == "Annual pay - Gross",
         AveragesAndPercentiles == "Mean",
         Sex == "All") %>%
  select(Time, administrative.geography, Geography,
         AveragesAndPercentiles, Sex, AvgPay)
