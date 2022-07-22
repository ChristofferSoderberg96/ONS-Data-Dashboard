# ******************************************************************************
# R script to generate [interactive] choropleth maps from local
# authority data
# ******************************************************************************

# Imports ----

library(rgdal)
library(htmlwidgets)
library(htmltools)
library(leaflet)
library(maptools)
library(rgeos)
library(sp)
library(RColorBrewer)

# Shapefile load ----

# Download latest local authority shapefile from ONS geoportal

if(!file.exists("LAShapeFiles")) {
  print("Please download the latest local authority shapefiles from https://geoportal.statistics.gov.uk/")
}

LAmap <- readOGR("LAShapeFiles/LAD_DEC_2021_GB_BFC.shp") # verify with plot()

# Merge local data with spatial data ----

source("LocalData.R")
source("LabourData.R")

## Add pay data ----

# check inconsistencies
setdiff(local_earnings$administrative.geography, LAmap$LAD21CD)

LAmap <-
  merge(LAmap, 
        select(local_earnings, administrative.geography, MedianPay), 
        by.x="LAD21CD", 
        by.y="administrative.geography")

## Add life satisfaction data ----

# check inconsistencies
setdiff(local_wellbeing$administrative.geography, LAmap$LAD21CD)

LAmap <-
  merge(LAmap, 
        select(local_wellbeing, administrative.geography, LifeSat),
        by.x="LAD21CD",
        by.y="administrative.geography")


# Static plots ----

# Palette of greens to represent earnings

earnings_colors <- colorRampPalette(brewer.pal(9, "Greens"))(50)
earnings_colors <- earnings_colors[as.numeric(cut(LAmap$MedianPay, 50))]

#set NAs to gray
for(i in 1:length(earnings_colors)) { if (is.na(earnings_colors[i])) {earnings_colors[i] = "#555555"}}

## Average earnings ----
#plot(LAmap, col = earnings_colors, bg = "#A6CAE0")

# Palette of purples to represent life satisfaction

lifesat_colors <- colorRampPalette(brewer.pal(9, "Purples"))(50)
lifesat_colors <- lifesat_colors[as.numeric(cut(LAmap$LifeSat, 50))]

#set NAs to gray
for(i in 1:length(lifesat_colors)) { if (is.na(lifesat_colors[i])) {lifesat_colors[i] = "#555555"}}

## Average life satisfaction ----
#plot(LAmap, col = lifesat_colors, bg = "#A6CAE0")


# Dynamic plots ----

# Convert spatial object type so that leaflet() can use it
LAlatlon <- spTransform(LAmap, CRS("+proj=longlat +datum=WGS84"))

# Interactive labels
datalabel <- paste (
  "Local Authority: ", LAlatlon$LAD21NM, "<br/>",
  "Median Annual Income (£):", format(LAlatlon$MedianPay, big.mark = ",", scientific = FALSE), "<br/>",
  "Mean Life Satisfaction (0-10): ", LAlatlon$LifeSat
) %>%
  lapply(htmltools::HTML)

# Palettes
earnings_pal <- colorBin("Greens",
                         LAlatlon$MedianPay,
                         bins = 6,
                         na.color = "#555555")

lifesat_pal <- colorBin("Purples",
                        LAlatlon$LifeSat,
                        bins = 6,
                        na.color = "#555555")

# Leaflet widget for earnings ----
LAmapEarnings <- leaflet(LAlatlon) %>%
  setView(lat = 52.5, lng = -1, zoom = 7) %>%
  setMaxBounds(lat1 = 48, lng1 = -8,
               lat2 = 60, lng2 = 4) %>%
  addPolygons(fillColor = earnings_pal(LAlatlon$MedianPay),
              fillOpacity = 1,
              stroke = TRUE,
              weight = 1.5, 
              color = "Black",
              label = datalabel,
              labelOptions = labelOptions( 
                style = list("font-weight" = "normal", padding = "3px 8px"), 
                textsize = "13px", 
                direction = "auto")
              ) %>%
  addLegend(pal = earnings_pal,
            values = ~LAlatlon$MedianPay,
            title = "Median Annual Income (£)",
            position = "bottomleft",
            na.label = "No data",
            opacity = 0.8)

# Leaflet widget for life satisfaction ----
LAmapLifesat <- leaflet(LAlatlon) %>%
  setView(lat = 52.5, lng = -1, zoom = 7) %>%
  setMaxBounds(lat1 = 48, lng1 = -8,
               lat2 = 60, lng2 = 4) %>%
  addPolygons(fillColor = lifesat_pal(LAlatlon$LifeSat),
              fillOpacity = 1,
              stroke = TRUE,
              weight = 1.5, 
              color = "Black",
              label = datalabel,
              labelOptions = labelOptions( 
                style = list("font-weight" = "normal", padding = "3px 8px"), 
                textsize = "13px", 
                direction = "auto")
  ) %>%
  addLegend(pal = lifesat_pal,
            values = ~LAlatlon$LifeSat
            ,
            title = "Mean Life Satisfaction (0-10):",
            position = "bottomleft",
            na.label = "No data",
            opacity = 0.8)

# Previews ----

LAmapEarnings

LAmapLifesat
