# GitHub Pages Deployment Plan for chrispitzer.com

## Overview
Deploy Hugo blog to GitHub Pages with custom domain `chrispitzer.com` (DNS on AWS).

## Steps

### 1. Update Hugo Configuration
- Edit `hugo.yaml` to change `baseURL` from `https://hugo-profile.netlify.app` to `https://chrispitzer.com`

### 2. Create CNAME File
- Create `static/CNAME` with content: `chrispitzer.com`
- This ensures the custom domain persists across deployments

### 3. Configure GitHub Repository
- Verify GitHub Pages is enabled in repo settings
- Set custom domain to `chrispitzer.com` in GitHub Pages settings
- Enable HTTPS (recommended)

### 4. Update AWS DNS
- Create CNAME record pointing to `<username>.github.io` OR
- Create ALIAS/A record if using apex domain (requires A records pointing to GitHub IPs)
- Note: For apex domains (chrispitzer.com without www), AWS requires ALIAS records

### 5. Test Deployment
- Run `./go.sh` → Deploy to GitHub Pages
- Verify site loads at chrispitzer.com

### 6. Delete This Plan Document
- Remove `DEPLOYMENT_PLAN.md` after successful deployment

## GitHub Pages URL Format
Your site will be at: `https://chrispitzer.github.io/mywebsite/` (if repo is named "mywebsite")
Or configure GitHub to serve from a custom repo at `chrispitzer.com`
