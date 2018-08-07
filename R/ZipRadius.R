#' The zipRadius Function
#'
#' @import zipcode
#' @import magrittr
#' @importFrom geosphere distHaversine
#' @importFrom dplyr filter, select, rename
#' @param zipcode the reference zip code of which you'd like the list of zip codes within a give radius as character
#' @param radius the distance in miles from the center of the given zip to the center of the other zips as numeric
#' @export zipRadius
#' @example zipRadius("30316", 10)
#'
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





