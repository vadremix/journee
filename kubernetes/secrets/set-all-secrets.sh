#!/bin/bash

# Navigate to the 'secrets' directory (assuming this script is run from the directory it resides in)
cd "$(dirname "$0")"

# Find and run each secret-setting script
for service_dir in */ ; do
    echo "Processing service: $service_dir"
    for script in "$service_dir"*.sh; do
        if [[ -f "$script" ]]; then
            echo "Running $script..."
            ./"$script"
        fi
    done
done

echo "All secret scripts executed."
