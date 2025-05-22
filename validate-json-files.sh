#!/bin/bash

# Function to check if content is valid JSON
is_valid_json() {
    echo "$1" | jq . >/dev/null 2>&1
    return $?
}

# Function to get default content for a file
get_default_content() {
    local file=$1
    case "$file" in
        *"cve_details.json") echo '{"CVE_Details": []}' ;;
        *"essential_links.json") echo '{}' ;;
        *"gdmf_cached.json") echo '{}' ;;
        *"gdmf_log.json") echo '{}' ;;
        *"iOS_beta_info.json") echo '{}' ;;
        *"iOS_rss_data.json") echo '[]' ;;
        *"macOS_beta_info.json") echo '{}' ;;
        *"macOS_rss_data.json") echo '[]' ;;
        *"model_identifier_"*.json) echo '{}' ;;
        *"supported_devices.json") echo '{}' ;;
        *"XProtect_rss_data.json") echo '[]' ;;
        *"macos_data_feed.json") echo '[]' ;;
        *"ios_data_feed.json") echo '[]' ;;
        *"timestamp.json") echo '{}' ;;
        *) echo '{}' ;;
    esac
}

echo "Validating JSON files..."

# Check all JSON files in cache and v1 directories
for dir in cache v1; do
    if [ -d "$dir" ]; then
        for file in "$dir"/*.json; do
            if [ -f "$file" ]; then
                echo -n "Checking $file... "
                
                # Read file content
                content=$(cat "$file" 2>/dev/null)
                
                # Check if file is empty or contains HTML (common error response)
                if [ -z "$content" ] || [[ "$content" == *"<!DOCTYPE html>"* ]] || [[ "$content" == *"<html"* ]]; then
                    echo "Invalid content detected, replacing with default JSON"
                    default_content=$(get_default_content "$file")
                    echo "$default_content" > "$file"
                elif ! is_valid_json "$content"; then
                    echo "Invalid JSON detected, replacing with default JSON"
                    default_content=$(get_default_content "$file")
                    echo "$default_content" > "$file"
                else
                    echo "Valid JSON"
                fi
            fi
        done
    fi
done

# Ensure public/v1 directory exists and copy valid files
mkdir -p public/v1
if [ -d "v1" ]; then
    cp v1/*.json public/v1/ 2>/dev/null || true
    cp v1/*.xml public/v1/ 2>/dev/null || true
fi

echo "JSON validation complete!"