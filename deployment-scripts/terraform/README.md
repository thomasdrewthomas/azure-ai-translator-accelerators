# Azure Solution Deployment Using Terraform

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Forking the Repository](#forking-the-repository)
4. [Setting Up GitHub Token for CI/CD](#setting-up-github-token-for-cicd)
5. [Terraform State Management](#terraform-state-management)
6. [Deployment Steps](#deployment-steps)
7. [Testing and Validation](#testing-and-validation)
8. [Additional Resources](#additional-resources)
9. [Security Enhancements](#security-enhancements)

## Overview
This repository contains Terraform code to deploy an Azure-based AI Translation solution using a simple, automated process. Additionally, we use GitHub Actions to facilitate CI/CD for deploying the app.

## Prerequisites
Before you start, ensure you have:
- [Terraform](https://www.terraform.io/downloads.html) installed locally.
- Access to an Azure subscription.
- A GitHub account and personal access token with necessary permissions.
- An Azure storage account and container for Terraform state management (see [Terraform State Management](#terraform-state-management) section).


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



## Terraform State Management

### Creating Azure Storage for Terraform State

To manage Terraform state remotely, you need to create an Azure storage account and container. Follow these steps:

1. Log in to the Azure Portal.
2. Create a new resource group (e.g., "terraform").
3. Create a new storage account in this resource group.
4. Within the storage account, create a new container named "tfstate".

You can do this using the Azure CLI:

```bash
az group create --name terraform --location eastus
az storage account create --name terraform9999 --resource-group terraform --sku Standard_LRS
az storage container create --name tfstate --account-name terraform9999
```

### Configuring Terraform Backend

The `backend.tf` file in this repository is pre-configured to use Azure storage for state management:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraform9999"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}
```

Make sure to update the `storage_account_name` to match the name of the storage account you created.

### Alternative State Management Options

1. **Local State Management**: For demo purposes or local development, you can manage the state locally. To do this, simply remove or comment out the `backend` block in `backend.tf`.

2. **Other Terraform Backends**: Terraform supports various backend types. You can modify `backend.tf` to use a different backend, such as S3, GCS, or Terraform Cloud. Refer to the [Terraform Backend Configuration](https://www.terraform.io/docs/language/settings/backends/index.html) documentation for more options.

Adjust your backend configuration based on your specific needs and security requirements.

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