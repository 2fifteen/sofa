# SOFA - 2fifteen Fork
**S**imple **O**rganized **F**eed for **A**pple Software Updates

![Sofa logo](./images/custom_logo.png "Optional title")

Hello 👋,

This is the **2fifteen fork** of SOFA, which provides an additional deployment of the SOFA feed with automatic synchronization from the upstream repository. This fork is **deployed on Cloudflare Pages** and is accessible at [sofa.2fifteen.io](https://sofa.2fifteen.io).

## What This Fork Does

This fork:
- **Automatically syncs** data feeds from the upstream [macadmins/sofa](https://github.com/macadmins/sofa) repository
- **Deploys to Cloudflare Pages** using GitHub Actions for reliable hosting
- **Updates feeds regularly** using scheduled GitHub Actions (every hour during business hours, every 4 hours otherwise)
- **Validates JSON data** before committing to prevent build failures from invalid upstream responses
- **Provides resilient deployment** that continues working even when upstream data fetches fail
- **Provides the same features** as the original SOFA, but with an alternative deployment endpoint

The automated sync ensures this deployment stays up-to-date with the official SOFA feed while providing an alternative hosting location with enhanced reliability.

**Original SOFA:** supports MacAdmins by efficiently tracking and surfacing information on updates for macOS and iOS. It consists of a machine-readable feed and user-friendly web interface, providing continuously up-to-date information on XProtect data, OS updates, and the details bundled in those releases.

Updated automatically via GitHub Actions, the SOFA feed is a dynamic, centralized, and accessible source of truth. It can be self-hosted, giving you complete assurances as to the provenance of the data your fleet and coworkers can consume. The goal is to streamline the monitoring of Apple's software releases, thereby boosting security awareness and administrative efficiency.

## Key Features

### Machine-Readable Feed, RSS Feed, and Web UI

- **JSON Feed**: Provides detailed, machine-readable data optimized for automated tools and scripts
- **RSS Feed**: Provides RSS Feed for use with entries sorted by date released
- **Web Interface**: Divided between the major version tabs at the top and organized into sections that cover the latest OS information, XProtect updates, and security details for each OS, SOFA facilitates both quick summaries and deep dives into relevant data points

## Deprecation notice
**IMPORTANT NOTE:** Update Your Use of SOFA Feed
- Implement a USER-AGENT in Custom Tools
To optimize hosting and caching for SOFA, please implement a user-agent in your integrations, tools, and workflows. This enhances performance and user interactions with SOFA.
- Update to the New Feed Location
Please update your scripts that are utilising the SOFA macOS and iOS feeds to point to **https://sofafeed.macadmins.io/v1/macos_data_feed.json** and **https://sofafeed.macadmins.io/v1/ios_data_feed.json** respectively.

The old feed addresses of https://sofa.macadmins.io/v1/macos_data_feed.json and https://sofa.macadmins.io/v1/ios_data_feed.json are **deprecated** and will be removed soon.

### Use Cases

SOFA supports a wide array of practical applications, whether for MacAdmin tooling directly or discussing the state of security on Apple platforms with security personnel.

- **Xprotect Monitoring**: Keep track of the latest XProtect updates centrally so agents running on your fleet can verify compliance with CIS/mSCP standards, ensuring Apple's tooling is up-to-date
- **Security Overviews**: Surface information on vulnerabilities (CVEs) and their exploitation status (KEV).
- **Track Countdowns**: Know both a timestamp and the days since a release was posted so you can track when management that delays the update being visible will elapse, or just use it to remind users that the clock is ticking on an update that addresses 'critical' issues
- **Documentation Access**: Use links to quickly view relevant Apple documentation and check detailed CVE information CVE.org, CISA.gov and NVD, and correlate those CVE's across platforms or major versions
- **Download Universal Mac Assistant**: Access the latest and all 'active' (currently signed) IPSW/Universal Mac Assistant (UMA) download links. These can be integrated into your custom reprovisioning workflows, such as EraseAndInstall, to streamline and enhance your device re-purpose/deployment processes
- **Self-Hosting**: Take control of the SOFA feed by self-hosting. Establish your fork as the authoritative source in your environment. Tailor the feed to meet your specific needs and maintain complete autonomy over its data

## Web UI Overview

### OS Version Card

- **Latest OS Version:** View details for the latest macOS and iOS releases, including version numbers, build identifiers, and release dates
- **Download Links:** Direct access to download latest installers like IPSW files (coming soon!) or Universal Mac Assistant (UMA) packages
- **Security and Documentation Links:** Quick access to relevant Apple documentation and security advisories

### XProtect Data Card (macOS Only)

- **Latest Versions Information:** Track the most current versions of XProtect
- **Verification Baseline:** Use as a baseline info for use in custom tools to ensure XProtect is up-to-date across your macOS fleet. This could be running compliance scripts or extension attributes. See some starter examples in [Tools](./tool-scripts)
- **Update Frequency Details:** See when XProtect was updated and the days since the latest release

### Security Updates Listing

- **Release Timelines:** Overview of the release dates and intervals between the latest security updates.
- **Vulnerability Details:**  For each CVE, links are provided to view detailed records at CISA.gov or CVE.org. Use 'Command-click' to open a CVE record on the NVD website, highlighting detailed info on actively exploited vulnerabilities and related security advisories
- **Search and Highlight**: Search for specific CVEs to identify which OS updates address the vulnerabilities

## RSS Overview

The RSS feed is generated using [feedgen](https://feedgen.kiesow.be/) by leveraging the same data generated for the data feed. It extracts `SecurityReleases` and injects them into individual entries, providing a streamlined and organized feed of the latest updates. The process involves:

1. **Loading Cache Data**: RSS data is loaded from cached JSON files from the `cache/` directory to ensure all previously fetched updates are considered.
1. **Writing to Cache**: New or updated data is written back to the cache, sorted by `ReleaseDate`.
1. **Diffing Data**: New feed results are compared against existing cached data to identify and handle new entries.
1. **Generate New Cache**: Updating the current cache files with new entries if new entries exist.
1. **Creating RSS Entries**: `SecurityReleases` from the data feed are used to create RSS entries, including handling specific data like `XProtect` configurations and payloads.
1. **Writing RSS Feed**: The sorted and updated entries are written to an RSS feed file (`v1/rss_feed.xml`) using `feedgen`.

## Getting Started

### Access the Web UI

Visit the [SOFA Web UI](https://sofa.macadmins.io) to start exploring SOFA's features

### Use the Feed Data

Access the feed directly for integration with automated tools or scripts. For production use, we strongly recommend self-hosting the feed to enhance reliability and security. For guidance on how to utilize and implement the feed, explore examples in the [Tools](./tool-scripts) section. For details on self-hosting, please refer to the section below.

## Fork-Specific Enhancements

### JSON Validation System

This fork includes a robust JSON validation system to prevent Cloudflare Pages build failures:

- **validate-json-files.sh**: A script that checks all JSON files before build and replaces invalid content with valid empty structures
- **GitHub Actions validation**: Both sync workflows validate JSON responses before saving to prevent committing HTML error pages
- **Automatic build-time validation**: The build process runs validation automatically via npm scripts

### Enhanced GitHub Actions

- **upstream_sync.yml**: Enhanced with JSON validation for all fetched data
- **cloudflare_deployment.yml**: Includes pre-build validation step
- Both workflows handle failures gracefully, ensuring the site remains deployable

## Self-Hosting SOFA

We believe that organizations needing tight control and ownership of the data they rely on should consider self-hosting SOFA. By cloning the repository into your own GitHub account and activating GitHub Actions to automatically build the feed at set intervals — or implementing a similar setup on platforms like GitLab — you ensure full control over how the data is determined, updated, and utilized. Additional documentation on self-hosting will be available to guide you through this process.
