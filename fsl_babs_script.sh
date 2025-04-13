#!/bin/bash

BABS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script is in: $BABS_SCRIPT_DIR"


SCRATCH_DIR=/orcd/scratch/bcs/001/djarecka/fsl_bidsapp
DATALAD_SET_DIR=/orcd/data/satra/002/datasets/simple2_datalad

# Set up logging - redirect all further output to a log file while still showing in console
LOG_FILE="$SCRATCH_DIR/babs_script_$(date +%Y%m%d_%H%M%S).log"
echo "=== Script started at $(date) ===" | tee $LOG_FILE
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Environment: SCRATCH_DIR=$SCRATCH_DIR, DATALAD_SET_DIR=$DATALAD_SET_DIR"

# Accept dataset name and input path as arguments
SITE_NAME="$1"  # Accept site name
DATASET_NAME="$2"  # Accept dataset name as second argument

if [ -z "$SITE_NAME" ] || [ -z "$DATASET_NAME" ]; then
    echo "Error: Missing arguments. Usage: $0 <site_name> <dataset_name>"
    exit 1
fi

source ~/.bashrc
conda activate simple_babs_test
mkdir -p $SCRATCH_DIR/fsl_bidsapp_${DATASET_NAME}

# Initialize BABS with the dataset-specific output directory
babs init \
    --datasets BIDS=$DATALAD_SET_DIR/$DATASET_NAME/$SITE_NAME \
    --container_ds $DATALAD_SET_DIR/simple2_containers \
    --container_name fsl-0-0-1 \
    --container_config $BABS_SCRIPT_DIR/fsl_babs_config.yaml \
    --processing_level subject \
    --queue slurm \
    $SCRATCH_DIR/fsl_bidsapp_${DATASET_NAME}/$SITE_NAME/

cd $SCRATCH_DIR/fsl_bidsapp_${DATASET_NAME}/$SITE_NAME
babs submit ${PWD} --all

