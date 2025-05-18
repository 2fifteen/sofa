#!/bin/bash

# Create directories
mkdir -p cache v1 public/v1

# Create empty JSON files with valid JSON structure if they don't exist
declare -a json_files=(
    "cache/cve_details.json"
    "cache/essential_links.json"
    "cache/gdmf_cached.json"
    "cache/gdmf_log.json"
    "cache/iOS_beta_info.json"
    "cache/iOS_rss_data.json"
    "cache/macOS_beta_info.json"
    "cache/macOS_rss_data.json"
    "cache/model_identifier_monterey.json"
    "cache/model_identifier_sequoia.json"
    "cache/model_identifier_sonoma.json"
    "cache/model_identifier_ventura.json"
    "cache/supported_devices.json"
    "cache/XProtect_rss_data.json"
    "v1/macos_data_feed.json"
    "v1/ios_data_feed.json"
    "v1/timestamp.json"
)

# Create empty JSON objects/arrays for missing files
for file in "${json_files[@]}"; do
    if [ ! -f "$file" ]; then
        if [[ "$file" == *"_rss_data.json" ]] || [[ "$file" == *"_data_feed.json" ]]; then
            echo "[]" > "$file"
        else
            echo "{}" > "$file"
        fi
        echo "Created empty $file"
    fi
done

# Create empty XML files
if [ ! -f "v1/rss_feed.xml" ]; then
    echo '<?xml version="1.0" encoding="UTF-8"?><rss version="2.0"><channel><title>SOFA Feed</title><description>Temporary placeholder</description></channel></rss>' > "v1/rss_feed.xml"
    echo "Created empty v1/rss_feed.xml"
fi

# Copy v1 files to public directory
cp v1/*.json public/v1/
cp v1/*.xml public/v1/

echo "Initialization complete!"