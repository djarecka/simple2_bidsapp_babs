#!/bin/bash



# Check if datasets file and dataset name are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <datasets_file> <dataset_name>"
    echo "  datasets_file: A text file with one dataset path per line"
    echo "  dataset_name: The name of the dataset (used for directory structure)"
    exit 1
fi

DATASETS_FILE="$1"
DATASET_NAME="$2"

# Check if file exists
if [ ! -f "$DATASETS_FILE" ]; then
    echo "Error: Dataset list file not found: $DATASETS_FILE"
    exit 1
fi

# Read each line from the file and process each dataset
while IFS= read -r dataset_path_raw; do
    # Trim trailing whitespace
    trimmed_line=$(echo "$dataset_path_raw" | sed 's/[[:space:]]\+$//')

    # Skip empty lines or lines starting with #
    [[ -z "$trimmed_line" || "$trimmed_line" =~ ^# ]] && continue

    # Extract site name (after last slash)
    site_name="${trimmed_line##*/}"

    echo "Processing site: $site_name"
    
    echo "==============================================="
    echo "Processing site: $site_name for dataset: $DATASET_NAME"
    echo "==============================================="

    
    # Call the main script with the dataset path and dataset name
    ./fsl_babs_script.sh "$site_name" "$DATASET_NAME"
    
    
    echo "Completed processing site: $site_name"
    echo ""
done < "$DATASETS_FILE"

echo "All sites for dataset $DATASET_NAME have been processed!"
