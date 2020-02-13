#' The zipRadius Function
#'
#' Find all zip codes within a radius of a specified zip code.
#' @param zipcode The reference zip code of which you'd like the list of zip
#' codes within a give radius as a character vector of length one.
#' @param radius The distance in miles from the center of the given zip to the
#' center of the other zips as numeric.
#' @return A data frame with six columns.
#' the length of the \code{zipcodes} argument.
#' \describe{
#' \item{zip}{Character. A zip code nearby to the reference zip code.}
#' \item{city}{Character. The cities containing the zip codes.}
#' \item{state}{Character. The states containing the zip codes.}
#' \item{latitude}{Numeric. The latitudes of the centers of the zip codes.}
#' \item{longitude}{Numeric. The longitudes of the centers of the zip codes.}
#' \item{Distance}{Numeric. The distance in miles from the center of the
#' reference zip code to the center of the zip code in that row.}
#' }
#' @examples
#' # A real zip code
#' zipRadius("30316", 10)
#'
#' # A made up zip code
#' zipRadius("99999", 10)
#' @importFrom magrittr %>%
#' @importFrom geosphere distHaversine
#' @importFrom dplyr filter select mutate
#' @importFrom rlang .data
#' @importFrom assertive.types assert_is_a_string assert_is_a_number
#'@export
zipRadius <- function(zipcode, radius) {
  assertive.types::assert_is_a_string(zipcode)
  assertive.types::assert_is_a_number(radius)

  # Get the lat/lon of the reference zip
  refPoint <- dplyr::filter(zipList, .data$zip == zipcode) %>%
    dplyr::select(refLon = .data$longitude, refLat = .data$latitude)
  if(nrow(refPoint) == 0) {
    warning("The zipcode you specified wasn't found.")
    bad_data <- tibble::tibble(
      zip = character(),
      city = character(), state = character(),
      latitude = character(), longitude = character(),
      Distance = numeric()
    )
    return(bad_data)
  }

  # Calculate distance from reference zip to others
  radius_earth_miles <- 3959
  new_zip_points <- zipList %>%
    select(.data$longitude, .data$latitude)
  distance <- geosphere::distHaversine(refPoint, new_zip_points, radius_earth_miles)

  zipList %>%
    dplyr::mutate(Distance = round(!!distance, 2)) %>%
    # Filter using unrounded distances
    dplyr::filter(!!distance < radius)
}

#' Get the US states near to a zip code
#'
#' \code{getStates} returns the list of states which have zip codes that fall
#' in a specified radius in lower case format for use in \code{choroplethrZip}.
#' @param zipcode The reference zip code of which you'd like the list of zip
#' codes within a give radius as character.
#' @param radius The distance in miles from the center of the given zip to the
#' center of the other zips as numeric.
#' @return A character vector of US state names, in lower case.
#' @examples
#' getStates("30316", 100)
#' @export
getStates <- function(zipcode, radius){
  data <- zipRadius(zipcode, radius)
  stateTable <- as.data.frame(cbind(datasets::state.abb, tolower(datasets::state.name)))
  zipStates <- unique(data$state)
  States <- as.character(stateTable[which(stateTable$V1 %in% zipStates),2])
  States
}

#' get the population living near a zip code
#'
#' \code{getZipPop} returns a data frame of zip codes and their population where
#'  the zip codes fall within a given radius for use in \code{choroplethrZip}.
#' @param zipcode The reference zip code of which you'd like the list of zip
#' codes within a give radius as character.
#' @param radius The distance in miles from the center of the given zip to the
#' center of the other zips as numeric.
#' @return A data frame with two columns.
#' the length of the \code{zipcodes} argument.
#' \describe{
#' \item{zip}{Character. A zip code nearby to the reference zip code.}
#' \item{population}{Numeric. The population of that zip code.}
#' }
#' @examples
#' getZipPop("30316", 10)
#' @importFrom dplyr select
#' @importFrom dplyr inner_join
#' @importFrom dplyr rename
#' @export
getZipPop <- function(zipcode, radius){
  data <- zipRadius(zipcode, radius)
  data(df_pop_zip)
  data %>%
    dplyr::select(.data$zip) %>%
    dplyr::inner_join(df_pop_zip, by = c("zip" = "region")) %>%
    dplyr::rename(population = value)
}

#' Get nearby zip codes
#'
#' \code{getZips} returns the list of zip codes as a character vector which have
#' zip codes which fall in a specified radius in lower case format for use in
#' \code{choroplethrZip}.
#' @param zipcode The reference zip code of which you'd like the list of zip
#' codes within a give radius as character.
#' @param radius The distance in miles from the center of the given zip to the
#' center of the other zips as numeric.
#' @return A character vector of zip codes.
#' @examples
#' getZips("30316", 10)
#'@export
getZips <- function(zipcode, radius){
  data <- zipRadius(zipcode, radius)
  zips <- data$zip
  zips
}

#' Lookup zip code location
#'
#' Get the city, state, latitude and longitude of zip codes
#' @param zipcodes A character vector of five digit zip codes
#' @return A data frame with five columns and as many rows as
#' the length of the \code{zipcodes} argument.
#' \describe{
#' \item{zip}{Character. The zip codes you passed to the function.}
#' \item{city}{Character. The cities containing the zip codes.}
#' \item{state}{Character. The states containing the zip codes.}
#' \item{latitude}{Numeric. The latitudes of the centers of the zip codes.}
#' \item{longitude}{Numeric. The longitudes of the centers of the zip codes.}
#' }
#' @examples
#' zipcodes <- c("99501", "90210", "33162", "60606", "42748", "99999")
#' lookupZips(zipcodes)
#' @importFrom tibble tibble
#' @importFrom dplyr filter
#' @export
lookupZips <- function(zipcodes) {
  tibble::tibble(zip = zipcodes) %>%
    dplyr::left_join(zipList, by = "zip")
}
