library(dplyr)

standardize_columns <- function(df, country_name, countries_config) {
  
  cfg <- countries_config[[country_name]]
  
  # Required columns
  required_cols <- c(
    "facility_name_column",
    "facility_code_column",
    "facility_type",
    "facility_ownership",
    "latitude",
    "longitude",
    "admin1_column"
    #"operation_status"  do NOT include operation_status if optional
  )
  
  # Check for missing config
  missing_cfg <- required_cols[!required_cols %in% names(cfg)]
  if (length(missing_cfg) > 0) {
    stop(paste0("Missing YAML config fields for ", country_name, ": ", paste(missing_cfg, collapse=", ")))
  }
  
  
  # Start renaming required columns
  df_clean <- df %>%
    rename(
      facility_name = !!sym(cfg$facility_name_column),
      facility_code = !!sym(cfg$facility_code_column),
      facility_type = !!sym(cfg$facility_type),
      facility_ownership = !!sym(cfg$facility_ownership),
      latitude      = !!sym(cfg$latitude),
      longitude     = !!sym(cfg$longitude),
      admin1        = !!sym(cfg$admin1_column)
      #status        = !!sym(cfg$operation_status)
      
    )
  
  # Optional columns
  if("operation_status" %in% names(cfg)) {
    df_clean <- df_clean %>%
      rename(status = !!sym(cfg$operation_status))
  } else {
    df_clean$status <- NA  # create empty column if not present
  }
  
  return(df_clean)
}