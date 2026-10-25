
#' Nominatim Reverse Geo-coding
#' 
#' @description
#' Get addresses from GPS coordinates using the OpenStreetMap Nominatim API.
#'
#' @param lng a numeric vector of longitude.
#' @param lat a numeric vector of latitude.
#' @param zoom a numeric value passed to the Nominatim API (see details).
#' @param addressdetails a numeric value passed to the Nominatim API (see details).
#' @param cache the path to the cache folder (see details).
#' @param timeout a numeric (in hours) when cache data is obsolete.
#' @param limit a numeric (in Mb) to define the cache size limit.
#' @param verbose a logical if logs should be printed to the console.
#' 
#' @details
#' `zoom` and `addressdetails` are defined the API documentation:
#' https://nominatim.org/release-docs/develop/api/Reverse
#'
#' Wrapping calls to the Nominatim API into a cache system is mandatory
#' to avoid IP banning (when too many requests are send for the same query).
#' 
#' The cache `timeout` is set to 1 year (8760 hours) and `limit` to 1 Mb.
#' Also encryption is not activated since the API returns open data.
#' 
#' Use the `R_KMAPS_CACHE` environment variable to define it.
#'
#' @returns a data.frame.
#' @export
#'
#' @examples
#' \dontrun{
#' # assuming R_KMAPS_CACHE environment variable has been set
#' rev_geocode(lng = 2.5, lat = 48.2)
#' rev_geocode(lng = c(2.5, -1.81602098644987), lat = c(48.2, 52.5487429714954))
#' }

rev_geocode <- function(lng, lat, zoom = 18, addressdetails = 1,
                        cache = Sys.getenv("R_KMAPS_CACHE"), timeout = 8760, limit = 1,
                        verbose = FALSE){
  
  # -- check
  stopifnot("lng & lat must have same length" = length(lng) == length(lat))

  # -- helper
  nominatim <- function(lng, lat, zoom, addressdetails){

    stopifnot("lng must be a numeric value" = is.numeric(lng))
    stopifnot("lat must be a numeric value" = is.numeric(lat))

    # -- init
    address <- "https://nominatim.openstreetmap.org"
    endpoint <- "reverse"
    format <- "json"
        
    # -- build query parameters
    params <- paste(paste0("format=", format),
                    paste0("lat=", lat),
                    paste0("lon=", lng),
                    paste0("zoom=", zoom),
                    paste0("addressdetails=", addressdetails),
                    sep = "&")
    
    # -- build url
    # https://nominatim.openstreetmap.org/reverse?format=json&lat=52.5487429714954&lon=-1.81602098644987&zoom=18&addressdetails=1
    url <- paste(paste(address, endpoint, sep = "/"), params, sep = "?")
    
    tryCatch({
      
      # -- call Nominatim API  
      res <- iker::call_api(url, header = list())
      
      if(res$status_code != 200)
        stop("Nominatim API status code", res$status_code)
      else
        jsonlite::fromJSON(res$content)},
      
      error = function(e) return(data.frame()))
    
  }
  
  # -- apply helper
  res <- t(mapply(\(x, y)

    # -- call Nominatim API  
    iker::with_cache(
      nominatim(lng = x, lat = y, zoom = zoom, addressdetails = addressdetails),
      path = cache,
      timeout = timeout,
      limit = limit,
      cleanup = "off",
      encrypt = FALSE,
      verbose = verbose), 
    
    lng, lat))
  
  # -- return
  as.data.frame(res)
  
}
