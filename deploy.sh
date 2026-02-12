#!/bin/bash
set -e

echo "🚀 Deploying Game Zone with Authentication..."

# Install Lambda dependencies
echo "📦 Installing Lambda dependencies..."
cd backend/lambda
npm install --production
cd ../../iac

# Initialize and apply Terraform
echo "🏗️  Deploying infrastructure..."
terraform init
terraform apply -auto-approve

# Get outputs
echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Configuration:"
terraform output -json > ../outputs.json

USER_POOL_ID=$(terraform output -raw cognito_user_pool_id)
CLIENT_ID=$(terraform output -raw cognito_client_id)
API_ENDPOINT=$(terraform output -raw api_endpoint)

echo ""
echo "🔧 Update src/js/auth.js with these values:"
echo "  userPoolId: '$USER_POOL_ID'"
echo "  clientId: '$CLIENT_ID'"
echo "  apiEndpoint: '$API_ENDPOINT'"
echo ""
echo "🌐 Website URL: $(terraform output -raw cloudfront_url)"
echo ""
