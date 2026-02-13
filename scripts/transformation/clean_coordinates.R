clean_coordinates <- function(df) {
  
  df %>%
    mutate(
      latitude  = as.numeric(latitude),
      longitude = as.numeric(longitude)
    ) 
    #filter(!is.na(latitude), !is.na(longitude))
  df <- df %>%
    select(
      facility_name,
      facility_code,
      facility_type,
      facility_ownership,
      latitude,
      longitude,
      admin1,
      status,
      #valid_coords
    )
  
  return(df)
}
  

