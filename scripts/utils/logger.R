log_message <- function(country, step, status, message = "") {
  
  log_entry <- data.frame(
    timestamp = Sys.time(),
    country = country,
    step = step,
    status = status,
    message = message
  )
  
  log_file <- "logs/pipeline_log.csv"
  
  # If log file exists → append without column names
  if (file.exists(log_file)) {
    
    write.table(
      log_entry,
      file = log_file,
      sep = ",",
      row.names = FALSE,
      col.names = FALSE,
      append = TRUE
    )
    
  } else {
    
    # If file does not exist → create with column names
    write.table(
      log_entry,
      file = log_file,
      sep = ",",
      row.names = FALSE,
      col.names = TRUE,
      append = FALSE
    )
  }
}