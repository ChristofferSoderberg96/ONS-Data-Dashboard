# ******************************************************************************
# R script to generate [interactive] choropleth maps from parsed local
# authority data
# ******************************************************************************

# Imports ----

library(rgdal)
library(htmlwidgets)
library(leaflet)

# Shapefile load ----

# Download latest local authority shapefile from ONS geoportal

if(!file.exists("LaShapeFiles")) {
  print("Please download the latest local authority shapefiles from https://geoportal.statistics.gov.uk/")
} #lmao

LAmap <- readOGR("LAShapeFiles/LAD_DEC_2021_GB_BFC.shp") # This works, verified with plot()

#LAmap_test <- leaflet(LAmap) %>% # This doesn't work
#  addTiles() %>%
#  setView(lat = 55, lng = -2, zoom = 5) %>%
#  addPolygons(color = "Blue") %>%
#  addPolylines(color = "Black")

# Merge local data with spatial data ----

source("LocalData.R")
source("LabourData.R")
