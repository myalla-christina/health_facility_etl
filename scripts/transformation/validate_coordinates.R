library(sf)
library(dplyr)
library(rnaturalearth)
library(rnaturalearthdata)

validate_coordinates <- function(df, country_name) {
  
  # Get country polygon from rnaturalearth
  country_shape <- ne_countries(scale = "medium", country = country_name, returnclass = "sf")
  
  # Convert df to sf object (skip rows with missing coordinates)
  df_sf <- df %>%
    filter(!is.na(latitude) & !is.na(longitude)) %>%
    st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
  
  # Check which points fall inside country polygon
  inside <- st_within(df_sf, country_shape, sparse = FALSE)[,1]
  
  # Add a flag to original df
  df$valid_coords <- NA  # default NA for missing coordinates
  df$valid_coords[!is.na(df$latitude) & !is.na(df$longitude)] <- inside
  
  return(df)
}