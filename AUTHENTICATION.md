# Game Zone - Complete Authentication System

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     AWS ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Users → CloudFront → S3 (Frontend)                            │
│           ↓                                                     │
│       Cognito (Auth) → API Gateway → Lambda → DynamoDB         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### Frontend
- **S3 + CloudFront**: Static website hosting
- **Pages**: index.html, login.html, profile.html, games
- **Auth Library**: js/auth.js (Cognito integration)

### Backend
- **AWS Cognito**: User authentication & management
- **API Gateway**: HTTP API with JWT authorization
- **Lambda**: Node.js 20.x API handlers
- **DynamoDB**: 
  - `user-profiles`: User data
  - `game-scores`: Game scores with leaderboard index

## API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | /profile | ✓ | Get user profile |
| PUT | /profile | ✓ | Update profile |
| POST | /scores | ✓ | Save game score |
| GET | /scores/{gameId} | ✓ | Get user scores |
| GET | /leaderboard/{gameId} | - | Public leaderboard |

## Deployment

### Prerequisites
- AWS CLI configured
- Terraform installed
- Node.js installed

### Deploy

```bash
cd /Workshop/game-zone
./deploy.sh
```

### Manual Steps After Deployment

1. **Update Frontend Config**:
   ```bash
   # Get values from terraform output
   cd iac
   terraform output
   ```

2. **Edit `src/js/auth.js`**:
   ```javascript
   const CONFIG = {
       userPoolId: 'YOUR_USER_POOL_ID',
       clientId: 'YOUR_CLIENT_ID',
       apiEndpoint: 'YOUR_API_ENDPOINT'
   };
   ```

3. **Redeploy Frontend**:
   ```bash
   terraform apply
   ```

## Database Schema

### user-profiles
```json
{
  "userId": "string (PK)",
  "username": "string",
  "createdAt": "ISO timestamp",
  "gamesPlayed": "number",
  "updatedAt": "ISO timestamp"
}
```

### game-scores
```json
{
  "userId": "string (PK)",
  "gameId": "string (SK)",
  "score": "number",
  "metadata": "object",
  "timestamp": "ISO timestamp"
}
```

## Features

✅ User registration & login  
✅ Email verification  
✅ JWT-based authentication  
✅ User profiles  
✅ Score tracking  
✅ Leaderboards  
✅ Secure API with Cognito authorizer  
✅ Infrastructure as Code  

## Cost Estimate

- **Cognito**: Free tier (50,000 MAUs)
- **API Gateway**: $1/million requests
- **Lambda**: Free tier (1M requests/month)
- **DynamoDB**: Free tier (25GB storage)
- **S3 + CloudFront**: ~$1-5/month

## Security

- Passwords: Min 8 chars, uppercase, lowercase, numbers
- JWT tokens with 1-hour expiration
- HTTPS only via CloudFront
- CORS configured for API
- DynamoDB encryption at rest

## Future Enhancements

- Social login (Google, Facebook)
- Password reset flow
- Email notifications
- Advanced game statistics
- Multiplayer features
- Real-time leaderboards (WebSocket)
