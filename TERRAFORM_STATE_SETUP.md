# Terraform State S3 Sync Setup

This guide helps you set up automatic syncing of Terraform state files to an S3 bucket using GitHub Actions.

## 🚀 Quick Setup

### 1. Deploy AWS Infrastructure

First, update the GitHub repository reference in `terraform-state-bucket.tf`:

```hcl
# Line 65: Update this with your actual GitHub repository
"token.actions.githubusercontent.com:sub" = "repo:YOUR_GITHUB_USERNAME/YOUR_REPO_NAME:*"
```

Then deploy the infrastructure:

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

**Important**: Save the outputs from `terraform apply` - you'll need them for GitHub secrets.

### 2. Configure GitHub Repository Secrets

Add these secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):

| Secret Name | Value | Source |
|-------------|-------|---------|
| `AWS_ROLE_ARN` | `arn:aws:iam::ACCOUNT:role/github-actions-terraform-state-role` | Terraform output: `github_actions_role_arn` |
| `S3_BUCKET_NAME` | `terraform-state-xxxxxxxx` | Terraform output: `s3_bucket_name` |

### 3. Update Workflow Configuration

Edit `.github/workflows/terraform-state-sync.yml`:

- Set your preferred AWS region in `AWS_REGION`
- Update `TF_VERSION` to match your Terraform version
- Adjust trigger paths if needed

## 📁 How It Works

### Automatic Sync Triggers

The workflow runs on:
- **Push to main/master** with `.tf` file changes
- **Pull requests** to main/master with `.tf` file changes  
- **Manual trigger** via GitHub Actions UI

### File Organization in S3

```
s3://your-terraform-state-bucket/
├── terraform-states/
│   ├── main/
│   │   ├── current/terraform.tfstate          # Latest state
│   │   └── 20240811_170308/terraform.tfstate  # Timestamped backup
│   └── feature-branch/
│       └── current/terraform.tfstate
└── terraform-plans/
    └── main/
        └── 20240811_170308/tfplan
```

### Security Features

- ✅ **Encrypted storage** with AES256
- ✅ **Versioning enabled** for state history
- ✅ **Public access blocked**
- ✅ **OIDC authentication** (no long-lived credentials)
- ✅ **Automatic cleanup** of local state files

## 🔧 Usage

### Automatic Operation

Once configured, the system works automatically:

1. Make changes to `.tf` files
2. Push to GitHub
3. GitHub Actions runs Terraform
4. State files are automatically synced to S3

### Manual State Restoration

To restore a state file from S3:

1. Go to **Actions** tab in GitHub
2. Select **Terraform State Sync to S3** workflow
3. Click **Run workflow**
4. The latest state for your branch will be downloaded

### Local Development

For local development, you can configure Terraform to use the S3 backend:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket-name"
    key    = "terraform-states/local/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## 🛠️ Customization

### Different AWS Region

Update these files:
- `variables.tf`: Change `aws_region` default
- `.github/workflows/terraform-state-sync.yml`: Update `AWS_REGION`

### Custom Bucket Name

Modify `terraform-state-bucket.tf`:
```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-custom-terraform-state-bucket"
  # Remove the random_string resource if using custom name
}
```

### Additional File Types

Add more file patterns to the workflow trigger:
```yaml
paths:
  - '**/*.tf'
  - '**/*.tfvars.example'
  - '**/*.hcl'  # Add this line
```

## 🔍 Troubleshooting

### Common Issues

**Error: "could not assume role"**
- Verify `AWS_ROLE_ARN` secret is correct
- Check that GitHub repository name matches the IAM role condition

**Error: "bucket does not exist"**
- Verify `S3_BUCKET_NAME` secret matches the actual bucket name
- Ensure Terraform infrastructure was deployed successfully

**No state files found**
- The workflow only syncs state files generated during CI/CD
- Local `.tfstate` files are gitignored and won't be synced

### Viewing Logs

Check GitHub Actions logs:
1. Go to **Actions** tab
2. Click on a workflow run
3. Expand the steps to see detailed logs

## 🔐 Security Best Practices

- ✅ Never commit `.tfstate` files to Git
- ✅ Use OIDC instead of access keys
- ✅ Limit IAM permissions to minimum required
- ✅ Enable S3 bucket versioning for recovery
- ✅ Monitor S3 access logs if needed

## 📞 Support

If you encounter issues:
1. Check the GitHub Actions logs
2. Verify all secrets are correctly configured
3. Ensure AWS permissions are properly set
4. Test with a simple Terraform configuration first
