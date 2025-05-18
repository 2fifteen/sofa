#!/bin/bash

# Create directories
mkdir -p cache v1 public/v1

# Create empty JSON files with valid JSON structure if they don't exist
declare -a json_files=(
    "v1/macos_data_feed.json|[]"
    "v1/ios_data_feed.json|[]"
    "v1/timestamp.json|{}"
    "cache/cve_details.json|{\"CVE_Details\": []}"
    "cache/essential_links.json|{}"
    "cache/gdmf_cached.json|{}"
    "cache/gdmf_log.json|{}"
    "cache/iOS_beta_info.json|{}"
    "cache/iOS_rss_data.json|[]"
    "cache/macOS_beta_info.json|{}"
    "cache/macOS_rss_data.json|[]"
    "cache/model_identifier_monterey.json|{}"
    "cache/model_identifier_sequoia.json|{}"
    "cache/model_identifier_sonoma.json|{}"
    "cache/model_identifier_ventura.json|{}"
    "cache/supported_devices.json|{}"
    "cache/XProtect_rss_data.json|[]"
)

# Create empty JSON files with proper structure
for entry in "${json_files[@]}"; do
    file="${entry%%|*}"
    content="${entry##*|}"
    if [ ! -f "$file" ]; then
        echo "$content" > "$file"
        echo "Created $file with structure: $content"
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