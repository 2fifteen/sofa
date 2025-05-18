# Cloudflare Deployment Setup for SOFA Fork

This guide explains how to deploy your SOFA fork on Cloudflare Pages with automatic upstream feed syncing.

## Prerequisites

1. GitHub account with this forked repository
2. Cloudflare account
3. Custom domain (optional)

## Setup Steps

### 1. Cloudflare Pages Setup

1. Log in to your Cloudflare dashboard
2. Go to Pages > Create a project
3. Connect your GitHub account and select this repository
4. Configure build settings:
   - Build command: `npm run docs:build`
   - Build output directory: `web/.vitepress/dist`
   - Root directory: `/`
   - Environment variables:
     - `NODE_VERSION`: `20`

### 2. Configure GitHub Secrets

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. `CLOUDFLARE_API_TOKEN` - Create this in Cloudflare dashboard:
   - Go to My Profile > API Tokens
   - Create Custom Token with permissions:
     - Account: Cloudflare Pages:Edit
     - Zone: Page Rules:Edit (if using custom domain)

2. `CLOUDFLARE_ACCOUNT_ID` - Find in Cloudflare dashboard (right sidebar)

### 3. Enable GitHub Actions

The repository includes two workflows:

1. **upstream_sync.yml** - Syncs data from upstream SOFA feed
   - Runs on schedule (every 4 hours)
   - Can be triggered manually
   - Only syncs data files

2. **cloudflare_deployment.yml** - Full build and deploy
   - Includes VitePress site build
   - Deploys to Cloudflare Pages
   - Use this for complete deployments

### 4. Initial Deployment

1. Enable GitHub Actions in your repository
2. Make the initialization script executable:
   ```bash
   git add init-empty-files.sh
   git commit -m "Add initialization script"
   git push
   ```
3. Run the "Sync Upstream SOFA Data" workflow manually first
4. Then run the "SOFA Feed Sync and Cloudflare Deployment" workflow
5. Your site should be live at `https://sofa-feed.pages.dev` (or your custom domain)

**Note**: The initialization script creates empty JSON files to prevent build errors on first deployment. These will be populated with real data from the upstream SOFA feed.

### 5. Custom Domain (Optional)

1. In Cloudflare Pages project settings, add your custom domain
2. Update DNS records as instructed
3. SSL certificate will be provisioned automatically

## Automatic Updates

The sync workflow runs automatically:
- Every hour during business hours (17-20 CET)
- Every 4 hours otherwise
- Can be triggered manually anytime

## Customization

### Modify Sync Schedule

Edit `.github/workflows/upstream_sync.yml`:
```yaml
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours
```

### Add Custom Data

You can add your own data processing:
1. Modify the workflows to run your custom scripts
2. Add processing steps before committing data
3. Keep upstream sync separate from custom processing

## Monitoring

1. Check GitHub Actions tab for workflow runs
2. Monitor Cloudflare Pages deployments
3. Set up alerts for failed workflows

## Troubleshooting

- **Workflow fails**: Check GitHub Actions logs
- **Deployment fails**: Check Cloudflare Pages build logs
- **Data not updating**: Verify upstream URLs are accessible
- **Site not loading**: Check Cloudflare DNS settings if using custom domain