# Azure Solution Deployment Using Terraform

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Forking the Repository](#forking-the-repository)
4. [Setting Up GitHub Token for CI/CD](#setting-up-github-token-for-cicd)
5. [Deployment Steps](#deployment-steps)
6. [Testing and Validation](#testing-and-validation)
7. [Additional Resources](#additional-resources)
8. [Security Enhancements](#security-enhancements)

## Overview
This repository contains Terraform code to deploy an Azure-based AI Translation solution using a simple, automated process. Additionally, we use GitHub Actions to facilitate CI/CD for deploying the app.

## Prerequisites
Before you start, ensure you have:
- [Terraform](https://www.terraform.io/downloads.html) installed locally.
- Access to an Azure subscription.
- A GitHub account and personal access token with necessary permissions.

## Forking the Repository
To begin, fork this repository to your own GitHub account:

1. Navigate to the main page of the repository.
2. Click the "Fork" button in the upper-right corner.
3. Select your GitHub account as the destination for the fork.
4. Once forked, clone your repository to your local machine:
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/azure-ai-translator-accelerators.git
   cd azure-ai-translator-accelerators/deployment-scripts/terraform
   ```

## Setting Up GitHub Token for CI/CD
Since we use GitHub Actions to deploy the application, you’ll need to generate a GitHub personal access token (PAT) with repo permissions. Follow these steps:

1. Go to your [GitHub Personal Access Tokens](https://github.com/settings/tokens) settings.
2. Click **Generate new token**.
3. Set a name for the token (e.g., `CI/CD Deployment Token`).
4. Under **Scopes**, select:
   - `repo`
   - `workflow`
5. Generate the token and save it somewhere secure (you won’t be able to view it again).


## Deployment Steps

## Deployment Steps

### 1. Clone the Repository
If you haven't already, clone your forked repository:
```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/azure-ai-translator-accelerators.git
cd azure-ai-translator-accelerators/deployment-scripts/terraform
```

### 2. Set Up Terraform Variables
Configure the deployment by updating the Terraform variables:

1. Rename the example variables file:
   ```bash
   mv terraform.dev-tfvars terraform.tfvars
   ```

2. Open `terraform.tfvars` in a text editor and update the following fields:
   ```hcl
   subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Your Azure subscription ID
   github_owner = "GITHUB_OWNER"  # Your GitHub username or organization
   github_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # Your GitHub personal access token
   ```

### 3. Initialize Terraform
Initialize the Terraform working directory:
```bash
terraform init
```
This command downloads the necessary provider plugins and sets up the backend.

### 4. Plan the Deployment
Generate and review an execution plan:
```bash
terraform plan
```
This shows you what changes Terraform will make to your Azure environment.

### 5. Apply the Terraform Configuration
Deploy the resources to Azure:
```bash
terraform apply -auto-approve
```
This command creates all the necessary resources in your Azure environment. The `-auto-approve` flag skips the approval prompt.



## Testing and Validation
After deployment, verify that all resources have been created successfully:
1. Log into the [Azure Portal](https://portal.azure.com/).
2. Navigate to the resource group specified in your Terraform configuration.
3. Ensure all expected resources are present and in a "Running" or "Active" state.
4. Test the functionality of your AI Translation solution using the provided endpoints.

## Additional Resources
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Azure Subscription Management](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Security Enhancements
To improve the security of your deployment, implement the following:

- [ ] Move the database into private subnets.
- [ ] Deploy OpenAI using private endpoints.
- [ ] Make Azure Function App only accessible from the VNet.
- [ ] Implement API Management security measures.
- [ ] Secure the Azure Storage Account.
- [ ] Secure the Azure Key Vault.
- [ ] Change Azure Functions communication to Azure Blob using RBAC.
- [ ] Secure the Azure Cognitive Services.
- [ ] Retrieve the database password from Azure Key Vault.