# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Frontend Development (VitePress/Vue)
```bash
npm install         # Install dependencies
npm run docs:dev    # Start development server at localhost:5173
npm run docs:build  # Build static site to web/.vitepress/dist
npm run docs:preview # Preview production build locally
```

### Python Script Execution
```bash
# Install Python dependencies first
pip install -r requirements.txt

# Main scripts
python build-sofa-feed.py    # Main feed builder - processes OS data and generates JSON feeds
python build-cve-cache.py    # Fetches CVE details from security APIs (requires VULNCHECK_API_KEY)
python process_ipsw.py       # Processes IPSW/installer data
python process_uma.py        # Processes Universal Mac Assistant data
python sofa-time-series.py   # Generates time series data

# Initialize empty cache files if needed
./init-empty-files.sh        # Creates initial empty JSON files in cache/
```

### Linting
```bash
# Python linting
ruff check .  # Check Python code style (configured in ruff.toml)
ruff format . # Format Python code
```

### Manual Feed Testing
```bash
# Generate feeds locally
python build-sofa-feed.py
# Copy to public directory
cp -r v1/* public/v1/
# Test with local dev server
npm run docs:dev
```

## Architecture Overview

### Data Pipeline
1. **Input**: Apple APIs, GDMF data, security feeds
2. **Processing**: Python scripts in root directory process raw data
3. **Storage**: `cache/` directory stores intermediate data
4. **Output**: Generated feeds in `v1/` and `public/v1/`
5. **Frontend**: VitePress site in `web/` consumes JSON feeds

### Key Directories
- `/cache` - Cached data including CVE details, device support, model identifiers
- `/v1` - Generated JSON feeds and RSS output
- `/web` - VitePress documentation site with Vue components
- `/web/components` - Reusable Vue components for UI features
- `/tool-scripts` - Example scripts for consuming SOFA data

### Configuration Files
- `config.json` - Defines tracked OS versions, UI elements, build names
- `forked_builds.json` - Maps build types to OS versions
- `feed_structure_template_v1.yaml` - Defines JSON feed schema
- `cloudflare-pages.json` - Cloudflare deployment configuration

### GitHub Actions Workflows
- `upstream_sync.yml` - Syncs data from upstream macadmins/sofa
- `fetch_cve_details.yml` - Fetches CVE security data
- `deploy.yml` - Deploys to GitHub Pages
- `cloudflare_deployment.yml` - Deploys to Cloudflare Pages
- `run_docker_macos_workflow.yml` - Containerized data processing

### Data Feed URLs
This fork syncs from upstream and deploys to:
- Production: https://sofa.2fifteen.io
- Feeds: https://sofa.2fifteen.io/v1/macos_data_feed.json
- RSS: https://sofa.2fifteen.io/v1/rss_feed.xml

## Fork-Specific Information

This is the 2fifteen fork which:
1. Automatically syncs from upstream macadmins/sofa repository
2. Deploys to Cloudflare Pages at sofa.2fifteen.io
3. Updates via scheduled GitHub Actions (hourly during business hours)
4. Includes JSON validation to prevent build failures

The sync workflow:
- Fetches macOS and iOS data feeds with validation
- Validates JSON before saving (rejects HTML error pages)
- Uses `validate-json-files.sh` to ensure all JSON is valid before builds
- Handles upstream failures gracefully

## Development Tips

### Working with Python Scripts
- Scripts expect cache directory to exist with JSON files
- Use `init-empty-files.sh` to create initial empty files
- Scripts output to `v1/` directory which should be copied to `public/v1/`

### Working with VitePress/Vue
- Components expect data feeds to exist in `/v1/` directory
- Use `DEBUG=true` environment variable for verbose output
- Components are in `web/components/` directory

### Testing Changes
1. Run Python scripts locally to generate test data
2. Use `npm run docs:dev` to preview changes
3. Check that JSON feeds are valid with `jq` command
4. Ensure GitHub Actions pass before merging

### Handling Build Failures

If Cloudflare Pages builds fail due to invalid JSON:
1. Run `./validate-json-files.sh` to fix JSON files
2. Check cache files for HTML content (404 errors)
3. The build process will automatically validate before building
4. GitHub Actions now validate JSON before committing