suppressWarnings(library(geosphere))
library(magrittr)
library(dplyr)
library(rlang)

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))

#' The zipRadius Function
#'
#' @import magrittr
#' @importFrom geosphere distHaversine
#' @importFrom dplyr filter select rename %>%
#' @importFrom utils zip
#' @importFrom rlang .data
#' @param zipcode the reference zip code of which you'd like the list of zip codes within a give radius as character
#' @param radius the distance in miles from the center of the given zip to the center of the other zips as numeric
#' @examples zipRadius("30316", 10)
#'@export
zipRadius <- function(zipcode, radius){
  # Get the lat/lon of the reference zip
  refPoint <- dplyr::filter(zipList, .data$zip == zipcode) %>%
    dplyr::select(.data$latitude, .data$longitude) %>%
    dplyr::rename(refLat = .data$latitude, refLon = .data$longitude)

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
  zipList <- dplyr::select(zipList, -.data$refLat, -.data$refLon) %>%
    dplyr::filter(.data$Distance < radius)

  return(zipList)
  }





