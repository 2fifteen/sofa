# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Frontend Development (VitePress/Vue)
```bash
npm run docs:dev    # Start development server at localhost:5173
npm run docs:build  # Build static site to web/.vitepress/dist
npm run docs:preview # Preview production build locally
```

### Python Script Execution
```bash
python build-sofa-feed.py    # Main feed builder - processes OS data and generates JSON feeds
python build-cve-cache.py    # Fetches CVE details from security APIs
python process_ipsw.py       # Processes IPSW/installer data
python process_uma.py        # Processes Universal Mac Assistant data
python sofa-time-series.py   # Generates time series data
```

### Linting
```bash
# Python linting
ruff check .  # Check Python code style (configured in ruff.toml)
ruff format . # Format Python code
```

### Deployment
```bash
# Cloudflare deployment (automatic via Actions)
npm run docs:build  # Build step for Cloudflare Pages
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

The sync workflow fetches:
- macOS and iOS data feeds
- Timestamp and RSS feeds  
- Cache files (when available)

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