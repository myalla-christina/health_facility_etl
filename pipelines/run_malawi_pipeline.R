library(yaml)


source("scripts/extraction/read_country_data.R") # ensure its excel or csv
source("scripts/transformation/standardize_columns.R")
source("scripts/transformation/clean_coordinates.R")
source("scripts/transformation/enforce_schema_types.R")
source("scripts/loading/save_standardized_data.R")

countries_config <- read_yaml("config/countries.yml")
schema <- load_schema("config/schema.yml")

country <- "uganda"

df_raw <- read_country_data(country, countries_config)

df_standardized <- df_raw %>%
  standardize_columns(country, countries_config) %>%
  clean_coordinates() %>% 
  enforce_schema_types(schema) 
#validate_schema(schema)


save_standardized_data(df_standardized, country)