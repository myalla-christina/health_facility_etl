library(yaml)
library(dplyr)

#library(yaml)
load_schema <- function(path = "config/schema.yml") {
  read_yaml(path)$standard_columns
}
load_schema <- function(path = "config/schema.yml") {
  read_yaml(path)$standard_columns
}

#Enforce data types

enforce_schema_types <- function(df, schema) {
  
  for (col in names(schema)) {
    
    if (!col %in% names(df)) next
    
    type <- schema[[col]]$type
    
    if (type == "string") {
      df[[col]] <- as.character(df[[col]])
    }
    
    if (type == "float") {
      df[[col]] <- as.numeric(df[[col]])
    }
    
    if (type == "integer") {
      df[[col]] <- as.integer(df[[col]])
    }
    
    if (type == "boolean") {
      df[[col]] <- as.logical(df[[col]])
    }
    
    if (type == "date") {
      df[[col]] <- as.Date(df[[col]])
    }
  }
  
  return(df)
}

# Validate schema rules
validate_schema <- function(df, schema) {
  
  for (col in names(schema)) {
    
    rules <- schema[[col]]
    
    # REQUIRED CHECK
    if (!is.null(rules$required) && rules$required) {
      if (!col %in% names(df)) {
        stop(paste("Missing required column:", col))
      }
    }
    
    # ALLOWED VALUES
    if (!is.null(rules$allowed_values) && col %in% names(df)) {
      invalid <- setdiff(unique(df[[col]]), rules$allowed_values)
      invalid <- invalid[!is.na(invalid)]
      
      if (length(invalid) > 0) {
        stop(paste("Invalid values in", col, ":", paste(invalid, collapse=", ")))
      }
    }
    
    # RANGE CHECKS
    if (!is.null(rules$min_value) && col %in% names(df)) {
      if (any(df[[col]] < rules$min_value, na.rm=TRUE)) {
        stop(paste(col, "below minimum allowed value"))
      }
    }
    
    if (!is.null(rules$max_value) && col %in% names(df)) {
      if (any(df[[col]] > rules$max_value, na.rm=TRUE)) {
        stop(paste(col, "above maximum allowed value"))
      }
    }
  }
  
  # UNIQUE FACILITY ID
  if ("facility_id" %in% names(df)) {
    if (anyDuplicated(df$facility_id)) {
      stop("Duplicate facility_id detected")
    }
  }
  
  return(TRUE)
}
























