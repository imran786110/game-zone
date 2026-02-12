# OAuth Setup Guide

## Guest Mode
✅ **Already Working!** Users can click "Continue as Guest" to play without signing up.

## Google OAuth Setup

### 1. Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable **Google+ API**
4. Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
5. Configure OAuth consent screen:
   - User Type: External
   - App name: Game Zone
   - Support email: your email
   - Authorized domains: `amazoncognito.com`
6. Create OAuth Client ID:
   - Application type: Web application
   - Authorized redirect URIs:
     ```
     https://imran-game-zone.auth.us-east-1.amazoncognito.com/oauth2/idpresponse
     ```
7. Copy **Client ID** and **Client Secret**

### 2. Update Terraform Variables

Edit `iac/terraform.tfvars`:
```hcl
enable_google_login  = true
google_client_id     = "YOUR_GOOGLE_CLIENT_ID"
google_client_secret = "YOUR_GOOGLE_CLIENT_SECRET"
```

### 3. Deploy
```bash
cd iac
terraform apply
```

---

## GitHub OAuth Setup

### 1. Create GitHub OAuth App

1. Go to [GitHub Settings](https://github.com/settings/developers)
2. Click **OAuth Apps** → **New OAuth App**
3. Fill in:
   - Application name: Game Zone
   - Homepage URL: `https://d14uok7hn0kap5.cloudfront.net`
   - Authorization callback URL:
     ```
     https://imran-game-zone.auth.us-east-1.amazoncognito.com/oauth2/idpresponse
     ```
4. Click **Register application**
5. Copy **Client ID**
6. Generate **Client Secret** and copy it

### 2. Update Terraform Variables

Edit `iac/terraform.tfvars`:
```hcl
enable_github_login  = true
github_client_id     = "YOUR_GITHUB_CLIENT_ID"
github_client_secret = "YOUR_GITHUB_CLIENT_SECRET"
```

### 3. Deploy
```bash
cd iac
terraform apply
```

---

## Current Login Options

✅ **Email/Password** - Working  
✅ **Guest Mode** - Working  
⏳ **Google** - Needs OAuth credentials  
⏳ **GitHub** - Needs OAuth credentials  

---

## Testing OAuth

After setup:

1. Visit: https://d14uok7hn0kap5.cloudfront.net/login.html
2. Click "Continue with Google" or "Continue with GitHub"
3. Authorize the app
4. You'll be redirected back and signed in automatically

---

## Security Notes

- OAuth credentials are sensitive - store securely
- Use Terraform variables or AWS Secrets Manager
- Never commit credentials to git
- Callback URLs must match exactly
