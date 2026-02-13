library(yaml)

source("scripts/extraction/read_country_data.R")
source("scripts/transformation/standardize_columns.R")
source("scripts/transformation/clean_coordinates.R")
source("scripts/loading/save_standardized_data.R")

countries_config <- read_yaml("config/countries.yml")

country <- "zambia"

df_raw <- read_country_data(country, countries_config)

df_standardized <- df_raw %>%
  standardize_columns(country, countries_config) %>%
  clean_coordinates()

save_standardized_data(df_standardized, country)