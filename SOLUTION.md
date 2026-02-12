# Game Zone - Complete Solution Architecture

## 🎯 Overview

A fully serverless gaming platform with user authentication, profile management, and score tracking built on AWS.

## 📦 What's Included

### Frontend (S3 + CloudFront)
- **Games**: Sudoku, Tetris, Snake
- **Authentication**: Login/Signup page
- **User Profile**: Profile management page
- **Auth Library**: JavaScript SDK for Cognito integration

### Backend (Serverless)
- **AWS Cognito**: User authentication & management
- **API Gateway**: RESTful API with JWT authorization
- **Lambda**: Node.js 20.x backend logic
- **DynamoDB**: User profiles & game scores database

### Infrastructure (Terraform)
All infrastructure defined as code:
- `main.tf` - S3 & CloudFront
- `cognito.tf` - User authentication
- `dynamodb.tf` - Database tables
- `lambda.tf` - Backend functions
- `api-gateway.tf` - API endpoints

## 🚀 Quick Start

### 1. Deploy Infrastructure

```bash
cd /Workshop/game-zone
./deploy.sh
```

This will:
- Install Lambda dependencies
- Deploy all AWS resources
- Output configuration values

### 2. Configure Frontend

After deployment, update `src/js/auth.js`:

```javascript
const CONFIG = {
    userPoolId: '<FROM_TERRAFORM_OUTPUT>',
    clientId: '<FROM_TERRAFORM_OUTPUT>',
    apiEndpoint: '<FROM_TERRAFORM_OUTPUT>'
};
```

Get values from:
```bash
cd iac
terraform output
```

### 3. Redeploy Frontend

```bash
cd iac
terraform apply
```

## 🔐 Authentication Flow

1. User signs up with email/password
2. Cognito sends verification email
3. User verifies email and logs in
4. Cognito returns JWT token
5. Frontend stores token in localStorage
6. API requests include JWT in Authorization header
7. API Gateway validates JWT with Cognito
8. Lambda processes authorized requests

## 📊 Database Schema

### user-profiles Table
- **PK**: userId (Cognito sub)
- **Attributes**: username, createdAt, gamesPlayed, updatedAt

### game-scores Table
- **PK**: userId
- **SK**: gameId
- **Attributes**: score, metadata, timestamp
- **GSI**: GameScoreIndex (gameId + score) for leaderboards

## 🌐 API Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| /profile | GET | ✓ | Get user profile |
| /profile | PUT | ✓ | Update username |
| /scores | POST | ✓ | Save game score |
| /scores/{gameId} | GET | ✓ | Get user's scores |
| /leaderboard/{gameId} | GET | - | Public leaderboard |

## 💰 Cost Estimate

**Free Tier Eligible:**
- Cognito: 50,000 MAUs free
- Lambda: 1M requests/month free
- DynamoDB: 25GB storage free
- API Gateway: 1M requests free (12 months)

**Ongoing Costs:**
- S3: ~$0.50/month
- CloudFront: ~$1-3/month
- Total: **~$2-5/month** for moderate traffic

## 🔒 Security Features

✅ Email verification required  
✅ Strong password policy (8+ chars, mixed case, numbers)  
✅ JWT tokens with expiration  
✅ API Gateway authorization  
✅ HTTPS only (CloudFront)  
✅ CORS configured  
✅ DynamoDB encryption at rest  
✅ IAM least privilege roles  

## 📁 Project Structure

```
game-zone/
├── src/                    # Frontend
│   ├── index.html         # Home page
│   ├── login.html         # Auth page
│   ├── profile.html       # User profile
│   ├── sudoku.html        # Sudoku game
│   ├── tetris.html        # Tetris game
│   ├── snake.html         # Snake game
│   ├── docs.html          # Documentation
│   └── js/
│       └── auth.js        # Auth SDK
├── backend/
│   └── lambda/
│       ├── index.js       # API handlers
│       └── package.json   # Dependencies
├── iac/                   # Terraform
│   ├── main.tf
│   ├── cognito.tf
│   ├── dynamodb.tf
│   ├── lambda.tf
│   ├── api-gateway.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── deploy.sh              # Deployment script
├── ARCHITECTURE.txt       # Architecture diagram
└── AUTHENTICATION.md      # Auth documentation
```

## 🎮 Game Integration Example

Add to any game HTML:

```html
<script src="js/auth.js"></script>
<script>
    // Check if user is logged in
    if (!auth.isAuthenticated()) {
        window.location.href = 'login.html';
    }

    // Save score when game ends
    async function gameOver(score) {
        await auth.saveScore('tetris', score, {
            level: currentLevel,
            lines: linesCleared
        });
    }

    // Show leaderboard
    async function showLeaderboard() {
        const scores = await auth.getLeaderboard('tetris');
        // Display scores...
    }
</script>
```

## 🔄 Update Workflow

1. Make changes to code
2. Commit to git: `git add -A && git commit -m "message" && git push`
3. Deploy: `cd iac && terraform apply`

## 🛠️ Troubleshooting

**Issue**: Login fails  
**Fix**: Check Cognito domain is unique, verify email

**Issue**: API returns 401  
**Fix**: Update CONFIG in auth.js with correct values

**Issue**: Lambda timeout  
**Fix**: Check CloudWatch logs, increase timeout in lambda.tf

## 📈 Future Enhancements

- [ ] Social login (Google, Facebook)
- [ ] Password reset flow
- [ ] Email notifications (SES)
- [ ] Real-time multiplayer (WebSocket API)
- [ ] Advanced analytics (CloudWatch Insights)
- [ ] Custom domain (Route 53 + ACM)
- [ ] CI/CD pipeline (GitHub Actions)

## 📞 Support

- Architecture: See `ARCHITECTURE.txt`
- Authentication: See `AUTHENTICATION.md`
- Deployment: See `iac/README.md`

---

**Built with AWS Serverless Architecture**  
Cognito • API Gateway • Lambda • DynamoDB • S3 • CloudFront
