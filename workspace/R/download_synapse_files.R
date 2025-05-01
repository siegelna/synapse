if (!requireNamespace("synapser", quietly = TRUE)) {
  stop("The 'synapser' package is required but not installed.")
}

# Load the package
library(synapser)

# This call initializes and logs in the `syn` object
synLogin(
  email = Sys.getenv("SYNAPSE_USERNAME"),
  authToken = Sys.getenv("SYNAPSE_APIKEY"),
  silent = TRUE
)



# Function to download files with metadata preservation
download_synapse_files <- function(file_table, output_dir = "data") {
  # Create main output directory
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  for (i in seq_len(nrow(file_table))) {
    row <- file_table[i, ]
    
    tryCatch({
      # Create specimen-specific directory
      specimen_dir <- file.path(output_dir, 
                               row$projectId,
                               row$specimenID,
                               row$assay)
      if (!dir.exists(specimen_dir)) {
        dir.create(specimen_dir, recursive = TRUE, showWarnings = FALSE)
      }
      
      # Download file if it doesn't exist
      target_file <- file.path(specimen_dir, row$dataFileName)
      if (!file.exists(target_file)) {
        cat("Downloading:", row$name, "\n")
        
        # Get the Synapse entity
        entity <- synGet(row$id, downloadLocation = specimen_dir)
        
        # Verify download integrity
        if (tools::md5sum(target_file) != row$dataFileMD5Hex) {
          warning("MD5 mismatch for: ", row$name)
          file.remove(target_file)
        }
      }
      
      # Save metadata as JSON
      metadata <- list(
        entityId = row$id,
        specimenID = row$specimenID,
        individualID = row$individualID,
        assay = row$assay,
        fileFormat = row$fileFormat,
        createdOn = row$createdOn
      )
      
      jsonlite::write_json(
        metadata,
        path = file.path(specimen_dir, paste0(row$dataFileName, ".metadata.json"))
      )
      
    }, error = function(e) {
      message("Failed to download ", row$name, ": ", conditionMessage(e))
    })
  }
}

# Execute download
download_synapse_files(file_table, output_dir = "synapse_data")

# Verify downloaded files
list.files("synapse_data", recursive = TRUE, pattern = "\\.gz$")