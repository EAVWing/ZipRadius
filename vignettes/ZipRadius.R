## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- include=FALSE------------------------------------------------------
library(zipcode)
library(geosphere)
library(magrittr)
library(dplyr)

data(zipcode)
zipList <- zipcode
rm(zipcode)

zipRadius <- function(zipcode, radius){

  # Get the lat/lon of the reference zip
  refPoint <- dplyr::filter(zipList, zip == zipcode) %>%
    dplyr::select(latitude, longitude) %>%
    dplyr::rename(refLat = latitude, refLon = longitude)

  # Add the lat/lon of the ref zip to the zipList
  zipList <- cbind(zipList, refPoint)

  # Radius of Earth in miles to adjust for km
  r = 3959

  # Creating Table of the coordinates. Makes it easy to calc distance
  Points1 <- cbind(zipList$longitude,zipList$latitude)
  Points2 <- cbind(zipList$refLon,zipList$refLat)
  distance <- distHaversine(Points1,Points2,r)

  # Adding distance back on to the original zipList
  zipList$Distance <- round(distance, 2)

  # Remove reference lat/lon and filter down to below selected radius
  zipList <- dplyr::select(zipList, -refLat, -refLon) %>%
    dplyr::filter(distance < radius)

  return(zipList)
  }

## ---- warning=FALSE------------------------------------------------------
test <- zipRadius("30316", 10)
head(test)

