# Game Zone - Terraform Deployment

## Architecture

- **S3 Bucket**: Hosts static HTML files with website hosting enabled
- **CloudFront**: CDN for global content delivery with HTTPS
- **Public Access**: Website accessible via CloudFront URL

## Prerequisites

- AWS CLI configured with credentials
- Terraform installed (v1.0+)

## Deployment Steps

1. **Update bucket name** (must be globally unique):
   ```bash
   cd iac
   # Edit terraform.tfvars and change bucket_name
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review plan**:
   ```bash
   terraform plan
   ```

4. **Deploy**:
   ```bash
   terraform apply
   ```

5. **Get CloudFront URL**:
   ```bash
   terraform output cloudfront_url
   ```

## Update Website Content

After modifying HTML files in `src/`:
```bash
cd iac
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Outputs

- `s3_bucket_name`: S3 bucket name
- `s3_website_endpoint`: Direct S3 website URL
- `cloudfront_domain`: CloudFront domain
- `cloudfront_url`: Full HTTPS URL to access your site
