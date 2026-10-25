# Nominatim Geo-coding

Get GPS coordinates from addresses using the OpenStreetMap Nominatim
API.

## Usage

``` r
geocode(
  x,
  cache = Sys.getenv("R_KMAPS_CACHE"),
  timeout = 8760,
  limit = 1,
  verbose = FALSE
)
```

## Arguments

- x:

  character vector of the addresses.

- cache:

  the path to the cache folder (see details).

- timeout:

  a numeric (in hours) when cache data is obsolete.

- limit:

  a numeric (in Mb) to define the cache size limit.

- verbose:

  a logical if logs should be printed to the console.

## Value

a data.frame.

## Details

Wrapping calls to the Nominatim API into a cache system is mandatory to
avoid IP banning (when too many requests are send for the same query).

The cache `timeout` is set to 1 year (8760 hours) and `limit` to 1 Mb.
Also encryption is not activated since the API returns open data.

Use the `R_KMAPS_CACHE` environment variable to define it.

## Examples

``` r
if (FALSE) { # \dontrun{
# assuming R_KMAPS_CACHE environment variable has been set
geocode("Musée du Louvre")
geocode(c("Musée du Louvre", "Musée d'Orsay"))
} # }
```
