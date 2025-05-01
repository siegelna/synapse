if (requireNamespace("synapser", quietly = TRUE)) {
  tryCatch({
    if (is.null(synapser::syn$getUserProfile())) {
      creds_available <- nzchar(Sys.getenv("SYNAPSE_USERNAME")) && 
                         nzchar(Sys.getenv("SYNAPSE_APIKEY"))

      if (creds_available) {
        message("\nSynapse: Found credentials in .Renviron")
        synapser::synLogin(
          email = Sys.getenv("SYNAPSE_USERNAME"),
          authToken = Sys.getenv("SYNAPSE_APIKEY"),
          silent = TRUE
        )
        message(paste0(
          "| Logged in as: ", synapser::syn$getUserProfile()$userName, "\n",
          "| Using Synapse client v", packageVersion("synapser"), "\n"
        ))
      } else {
        message("\nSynapse: No credentials found in .Renviron")
        message("To log in manually, use: synapser::synLogin()\n")
      }
    }
  }, error = function(e) {
    warning("Synapse login failed: ", conditionMessage(e))
  })
}

source("./R/download_synapse_files.R")