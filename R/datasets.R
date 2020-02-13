#' zipList
#'
#' US zip codes, and their city, state, latitude, and longitude.
#'
#' @docType data
#' @name zipList
#' @format A data frame with five columns and 44336 rows.
#' \describe{
#' \item{zip}{Character. Five-digit US zip codes.}
#' \item{city}{Character. The cities containing the zip codes.}
#' \item{state}{Character. The states containing the zip codes.}
#' \item{latitude}{Numeric. The latitudes of the centers of the zip codes.}
#' \item{longitude}{Numeric. The longitudes of the centers of the zip codes.}
#' }
#' @export
NULL

#' df_pop_zip
#' A data.frame containing population estimates for US Zip Code Tabulated Areas (ZCTAs) in 2012.
#'
#' ZCTAs are intended to be roughly analogous to postal ZIP codes.
#'
#' @name df_pop_zip
#' @docType data
#' @references Taken from the US American Community Survey (ACS) 5 year estimates.
#' ZCTAs, and their realationship to ZIP codes, are explained here \url{https://www.census.gov/geo/reference/zctas.html}.
#' @keywords data
#' @usage data(df_pop_zip)
NULL
