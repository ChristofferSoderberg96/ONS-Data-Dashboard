# ******************************************************************************
# R script to organise target URLs into lists
# ******************************************************************************

# Imports ----

library(tidyverse)
library(textreadr)
library(rvest)

# CSV download function

csvDownload <- function(urls, datalist) {
  for (i in 1:length(urls)) {
    datalist[[i]] <- read.csv(html_attr(html_element(read_html(urls[[i]]),
                                               "#csv-download"), "href"))
  }
  return(datalist)
}

# Date variables ----

cYear <- format(Sys.Date(), "%Y")
cMonth <- format(Sys.Date(), "%B")
cYearMonth <- format(Sys.Date(), "%B-%Y")
cDate <- format(Sys.Date(), "%D")

# Target webpages ----

# Local data ----

localURLs <- 
  list("https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/2", #wellbeing (1)
       "https://www.ons.gov.uk/datasets/life-expectancy-by-local-authority/editions/time-series/versions/1") #life exp (2)

# Labour market data ----

#Get latest ASHE table

asheURL <- "https://www.ons.gov.uk/datasets/ashe-tables-7-and-8/editions"

if(is.na(html_element(read_html(asheURL), paste0("#edition-", cYear)))) {
  asheURL <- paste0("https://www.ons.gov.uk", 
                    html_attr(html_element(read_html(asheURL), 
                                    paste0("#edition-", 
                                           as.character(as.numeric(cYear)-1))), "href"))
} else {
  asheURL <- paste0("https://www.ons.gov.uk", 
                    html_attr(html_element(read_html(asheURL),
                                    paste0("#edition-", 
                                           cYear)), "href"))
}

labourURLs <- 
  list(asheURL) # earnings and hours (1)
