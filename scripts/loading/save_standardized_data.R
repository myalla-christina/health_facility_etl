library(readr)

save_standardized_data <- function(df, country_name) {
  
  output_path <- paste0(
    "data/processed/country_standardized/",
    country_name,
    "_standardized.csv"
  )
  
  write_csv(df, output_path)
}