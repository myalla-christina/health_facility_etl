library(yaml)
library(dplyr)

# Utilities
source("pipelines/run_country_pipeline.R")
source("scripts/transformation/enforce_schema_types.R")
source("scripts/utils/logger.R")
#source("config/schema.R")

# Load config and schema
countries_config <- read_yaml("config/countries.yml")
schema <- load_schema("config/schema.yml")

# Prepare colClasses vector
col_classes <- sapply(schema, function(x) {
  if(x$type == "string") "character"
  else if(x$type == "integer") "integer"
  else if(x$type == "float") "numeric"
  else if(x$type == "boolean") "logical"
  else if(x$type == "date") "Date"
  else "character"
})

# List of countries
countries <- names(countries_config$countries)

# 1️⃣ Run all country pipelines
for (country in countries) {
  
  cat("Running pipeline for:", country, "\n")
  
  tryCatch({
    run_country_pipeline(
      country = country,
      countries_config = countries_config,
      schema = schema
    )
    log_message(country, "pipeline", "SUCCESS", "Country pipeline completed")
    
  }, error = function(e) {
    log_message(country, "pipeline", "FAIL", e$message)
    cat("Error running pipeline for", country, ":", e$message, "\n")
  })
}

# 2️⃣ Merge all country CSVs into global dataset

input_folder <- "data/processed/country_standardized"
output_folder <- "data/processed/global_master"

# Ensure output folder exists
if(!dir.exists(output_folder)) dir.create(output_folder, recursive = TRUE)

# List CSV files
files <- list.files(input_folder, pattern = "\\.csv$", full.names = TRUE, recursive = FALSE)
print("Files found for merging:")
print(files)

if(length(files) == 0) {
  stop("No country CSV files found in ", input_folder)
}

# Read all CSVs
country_datasets <- lapply(files, read.csv, stringsAsFactors = FALSE)

country_datasets <- lapply(country_datasets, function(df) {
  # Add missing columns as NA
  for(col in names(schema)) {
    if(!col %in% names(df)) df[[col]] <- NA
  }
  
  # Enforce column types
  enforce_schema_types(df, schema)
})

# Merge
global_dataset <- bind_rows(country_datasets, .id = "file")
global_dataset$country <- gsub(".*/|_standardized\\.csv", "", global_dataset$file)
global_dataset$file <- NULL


# Save global dataset
write.csv(global_dataset, file.path(output_folder, "global_health_facilities.csv"), row.names = FALSE)

log_message("GLOBAL", "merge", "SUCCESS",
            paste("Total rows in global dataset:", nrow(global_dataset)))

cat("Global pipeline completed successfully. Total rows:", nrow(global_dataset), "\n")