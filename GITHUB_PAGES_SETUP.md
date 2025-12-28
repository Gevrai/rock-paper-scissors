# GitHub Pages Deployment Guide

## Setup

1. **Enable GitHub Pages in your repository settings:**
   - Go to your repository on GitHub
   - Navigate to Settings → Pages
   - Under "Build and deployment", select:
     - Source: **GitHub Actions**
   - Save

2. **Push the workflow file to your main branch:**
   ```bash
   git add .github/workflows/deploy.yml
   git commit -m "Add GitHub Pages deployment workflow"
   git push origin main
   ```

## How it works

The workflow (`.github/workflows/deploy.yml`) will:
- Trigger automatically on every push to the `main` branch
- Download Godot 4.5 (stable)
- Build an HTML5 export of your project
- Deploy the build to GitHub Pages

## Access your game

Once deployed, your game will be available at:
```
https://<your-username>.github.io/<repository-name>/
```

For example, if your username is `gejora` and repo is `rock-paper-scissors`:
```
https://gejora.github.io/rock-paper-scissors/
```

## Manual deployment

You can also trigger a deployment manually:
1. Go to your repository on GitHub
2. Navigate to Actions
3. Select "Deploy to GitHub Pages"
4. Click "Run workflow"

## Troubleshooting

- **Build fails**: Check the workflow logs in the Actions tab for error details
- **Page not loading**: Ensure GitHub Pages is enabled and the workflow completed successfully
- **Wrong URL**: Verify your repository name and GitHub username in the Pages URL

## Updating your game

Simply push changes to `main` and the workflow will automatically rebuild and redeploy!
