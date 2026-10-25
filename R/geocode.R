

#' Nominatim Geo-coding
#' 
#' @description
#' Get GPS coordinates from addresses using the OpenStreetMap Nominatim API.
#'
#' @param x character vector of the addresses.
#' @param cache the path to the cache folder (see details).
#' @param timeout a numeric (in hours) when cache data is obsolete.
#' @param limit a numeric (in Mb) to define the cache size limit.
#' @param verbose a logical if logs should be printed to the console.
#' 
#' @details
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
#' geocode("Musée du Louvre")
#' geocode("Musée du Louvre", "Musée d'Orsay)
#' }

geocode <- function(x, cache = Sys.getenv("R_KMAPS_CACHE"), timeout = 8760, limit = 1, verbose = FALSE){
  
  # -- check
  stopifnot("cache can't be empty, check R_KMAPS_CACHE environment variable" = cache != "")
  stopifnot("cache directory does not exist" = dir.exists(cache))
  
  # -- helper
  # address: character string
  nominatim <- function(address = NULL){
    
    if(is.null(address))
      return(data.frame())
    
    tryCatch({
      
      # build url
      url <- gsub('\\@addr\\@', gsub('\\s+', '\\%20', address),
                  'https://nominatim.openstreetmap.org/search?q=@addr@&format=json&addressdetails=0&limit=1')
      
      # call Nominatim API
      res <- iker::call_api(url = url, header = list())
      
      if(res$status_code != 200)
        stop("Nominatim API status code", res$status_code)
      else
        jsonlite::fromJSON(res$content)},
      
      # -- failure  
      error = function(e) return(data.frame()))
    
  }
  
  # -- apply helper
  # wrap into cache to avoid IP ban
  m <- t(sapply(x, \(y) iker::with_cache(nominatim(address = y),
                                         path = cache,
                                         timeout = timeout,
                                         limit = limit,
                                         cleanup = "off",
                                         encrypt = FALSE,
                                         verbose = verbose)))
  
  # -- return
  as.data.frame(m)
  
}
