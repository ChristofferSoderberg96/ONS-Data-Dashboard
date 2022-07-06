# ******************************************************************************
# R script to perform analysis on local authority data collected from
# WebScrapes.R
# ******************************************************************************

# Imports ----

source("ONS_URLs.R")

# Web scrape relevant data ----

localData <- list()

for (i in 1:length(localURLs)) {
  localData[[i]] <- read.csv(html_attr(html_element(read_html(localURLs[[i]]),
                                                    "#csv-download"), "href"))
}

# Data cleaning ----

local_wellbeing <- localData[[1]]
local_lifeexp <- localData[[2]]
local_ageing <- localData[[3]]