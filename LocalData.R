# ******************************************************************************
# R script to perform analysis on local authority data specified in ONS_URLs.R
# ******************************************************************************

# Imports ----

source("ONS_URLs.R")

# Web scrape relevant data ----

localData <- list()
localData <- csvDownload(localURLs, localData)

# Data name set ----

local_wellbeing <- localData[[1]]
local_lifeexp <- localData[[2]]

# Data cleaning ----

## Wellbeing data ----

names(local_wellbeing)[1] <- "LifeSat" #measurement of life satisfaction

local_wellbeing <- local_wellbeing %>%
  select(Time, administrative.geography, Geography, 
         MeasureOfWellbeing, Estimate, LifeSat, Lower.limit, Upper.limit) %>%
  mutate(data_age = (as.numeric(cYear) - as.numeric(substr(local_wellbeing$Time, 1, 4)))) %>%
  filter(Estimate == "Average (mean)",
         MeasureOfWellbeing == "Life Satisfaction") %>%
  filter(data_age == min(data_age))

## Life expect data ----

names(local_lifeexp)[1] <- "LifeExp" #measurement of expected additional life years

local_lifeexp <- local_lifeexp %>%
  select(Time, administrative.geography, Geography, 
         Sex, AgeGroups, LifeExp, Lower.CI, Upper.CI) %>%
  mutate(data_age = (as.numeric(cYear) - as.numeric(substr(local_lifeexp$Time, 1, 4)))) %>%
  filter(data_age == min(data_age))
