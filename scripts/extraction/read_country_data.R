library(readr)
library(readxl)

read_country_data <- function(country_name, countries_config) {
  
  file_path <- countries_config[[country_name]]$raw_file
  
  if (grepl(".csv$", file_path)) {
    df <- read_csv(file_path)
  } else if (grepl(".xlsx$", file_path)) {
    df <- read_excel(file_path)
  } else {
    stop("Unsupported file type")
  }
  
  return(df)
}