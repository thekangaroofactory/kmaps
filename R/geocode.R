

#' Nominatim Geo-coding
#' 
#' @description
#' Get GPS coordinates from addresses using the Nominatim OSM API.
#'
#' @param x character vector of the addresses.
#'
#' @returns a data.frame.
#' @export
#'
#' @examples
#' \dontrun{
#' geocode("Musée du Louvre")
#' }

geocode <- function(x){
  
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
  m <- t(sapply(x, nominatim))
  
  str(m)
  
  # -- return
  as.data.frame(m)
  
}
