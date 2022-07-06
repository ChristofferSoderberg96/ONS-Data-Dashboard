# ******************************************************************************
# R script to organise target URLs into lists
#
# ******************************************************************************

# Imports ----

library(tidyverse)
library(textreadr)
library(rvest)

# Target webpages ----

# Local data

localURLs <- 
  list("https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/2", #wellbeing (1)
       "https://www.ons.gov.uk/datasets/life-expectancy-by-local-authority/editions/time-series/versions/1", #life exp (2)
       "https://www.ons.gov.uk/datasets/ageing-population-projections/editions/time-series/versions/1") #ageing (3)

# Labour market data

labourURLs <- list()
