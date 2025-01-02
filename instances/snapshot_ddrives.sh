#!/bin/bash

# Set the current date
CURRENT_DATE=$(date +"%Y-%m-%d")

# Function to validate and clean snapshot name
validate_snapshot_name() {
    local drive="$1"
    # Remove any invalid characters, ensure it starts with a lowercase letter
    # and is between 1-63 characters long
    local cleaned_name=$(echo "$drive-final-$CURRENT_DATE" | \
        tr '[:upper:]' '[:lower:]' | \
        sed -E 's/[^a-z0-9-]//g' | \
        sed -E 's/^[^a-z]//' | \
        sed -E 's/^(.{63}).*/\1/')
    
    echo "$cleaned_name"
}

# Read the CSV file and create snapshots
while IFS= read -r drive
do
    # Skip empty lines
    [[ -z "$drive" ]] && continue

    # Validate and clean the snapshot name
    SNAPSHOT_NAME=$(validate_snapshot_name "$drive")

    # Create snapshot command with validated name
    gcloud compute snapshots create "$SNAPSHOT_NAME" \
        --project=sdl-lan \
        --source-disk="$drive" \
        --source-disk-zone=us-east1-d \
        --snapshot-type=ARCHIVE \
        --storage-location=us
done < ddrive.csv