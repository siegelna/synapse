## Build Image
```shell
docker build -t sc-synapse-env .
```

## Launch Image
```shell
docker run -it --rm \
  -v "$PWD/workspace":/workspace \
  sc-synapse-env
```

## Finding Dataset
1. Search synapse ID [https://arkportal.synapse.org/](https://arkportal.synapse.org/)
    - Make sure you have approval
    - Request approval if not already granted
2. Select files of interest (i.e. rds, fastq, mtx, etc.)
3. Click on `Download Options` and select to export csv table of files

## Run
```r
# Load a job
file_table <- read.csv("./Jobs/syn54407831.csv", stringsAsFactors = FALSE)
print(head(file_table))
```

```r
# Execute download
download_synapse_files(file_table, output_dir = "synapse_data")

# Verify downloaded files
list.files("synapse_data", recursive = TRUE, pattern = "\\.gz$")
```

## Troubleshooting
```shell
docker build --no-cache -t sc-synapse-env .
```

### Download Fails
```
Downloading: 2023-03-02_rawCounts_Nuc_QCed.rds 
Failed to download 2023-03-02_rawCounts_Nuc_QCed.rds: 
This entity has access restrictions. Please visit the web page for this entity (syn.onweb("syn51179513")). Look for the "Access" label and the lock icon underneath the file name. Click "Request Access", and then review and fulfill the file download requirement(s).
```

Try requesting access to the specific dataset that produced the error.
```
https://www.synapse.org/#!Synapse:syn51179513
```
## To-do
- [ ] Make output files accessible to virual machine outside of Docker container