library(yaml)
library(dplyr)

source("scripts/utils/logger.R")
source("scripts/extraction/read_country_data.R")
source("scripts/transformation/standardize_columns.R")
source("scripts/transformation/clean_coordinates.R")
source("scripts/transformation/enforce_schema_types.R")
source("scripts/loading/save_standardized_data.R")

run_country_pipeline <- function(country, countries_config, schema) {
  
  log_message(country, "pipeline", "START")
  
  tryCatch({
    
    df <- read_country_data(country, countries_config) %>%
      standardize_columns(country, countries_config) %>%
      clean_coordinates() %>%
      enforce_schema_types(schema)
    
    save_standardized_data(df, country)
    
    log_message(country, "pipeline", "SUCCESS",
                paste("Rows:", nrow(df)))
    
    return(df)
    
  }, error = function(e) {
    
    log_message(country, "pipeline", "FAILED", e$message)
    return(NULL)
  })
}