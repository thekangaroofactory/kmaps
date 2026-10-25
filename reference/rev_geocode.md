# Nominatim Reverse Geo-coding

Get addresses from GPS coordinates using the OpenStreetMap Nominatim
API.

## Usage

``` r
rev_geocode(
  lng,
  lat,
  zoom = 18,
  addressdetails = 1,
  cache = Sys.getenv("R_KMAPS_CACHE"),
  timeout = 8760,
  limit = 1,
  verbose = FALSE
)
```

## Arguments

- lng:

  a numeric vector of longitude.

- lat:

  a numeric vector of latitude.

- zoom:

  a numeric value passed to the Nominatim API (see details).

- addressdetails:

  a numeric value passed to the Nominatim API (see details).

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

`zoom` and `addressdetails` are defined the API documentation:
https://nominatim.org/release-docs/develop/api/Reverse

Wrapping calls to the Nominatim API into a cache system is mandatory to
avoid IP banning (when too many requests are send for the same query).

The cache `timeout` is set to 1 year (8760 hours) and `limit` to 1 Mb.
Also encryption is not activated since the API returns open data.

Use the `R_KMAPS_CACHE` environment variable to define it.

## Examples

``` r
if (FALSE) { # \dontrun{
# assuming R_KMAPS_CACHE environment variable has been set
rev_geocode(lng = 2.5, lat = 48.2)
rev_geocode(lng = c(2.5, -1.81602098644987), lat = c(48.2, 52.5487429714954))
} # }
```
