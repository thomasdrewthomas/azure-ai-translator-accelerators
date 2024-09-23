# Variables

# Function to generate a random 5-character string
function Get-RandomString {
    -join ((97..122) | Get-Random -Count 5 | ForEach-Object { [char]$_ })
}

#$randomString = Get-RandomString

$subscriptionId = "520838e5-950d-4a4e-905c-e300c984837b"
$resourceGroupName = "ai-translator-accelerator-rg-vwuif"
$location = "uksouth"
$storageAccountName = "azaitranslatorvwuif" # Must be between 3 and 24 characters, only lower-case letters and numbers
$appServicePlanName = "azure-ai-translator-plan-vwuif"
$functionAppNameUpload = "ai-translator-upload-func-vwuif"
$functionAppNameTranslate = "ai-translator-translate-func-vwuif"
$functionAppNameWatermark = "ai-translator-watermark-func-vwuif"
$storageContainerName = "documents"
$translationSku = "S1"
$CosmosDBName = "translateservicevwuif"
# Translation Service variables
$translationServiceName = "ai-trans-service-vwuif"
$customDomain = "ai-translator-vwuif"

# OpenAI specific variables
$openAIServiceName = "az-openai-service-vwuif" #$randomString
$openAISku = "S0"
$chatCompletionsModelName = "gpt-35-turbo" # Adjust as needed
$chatCompletionsDeploymentName = "az-chat-vwuif"

# Static Web App variables
$repositoryUrl = "https://github.com/thomasdrewthomas/azure-ai-translator-accelerators"
$branchName = "main"
$webAppFolder = "document-translate-web"
$accessToken = "" # Replace this with your GitHub access token
$staticWebAppName = "ai-translator-static-webapp-vwuif"
$staticSitesRegion = "westeurope" # Adjust as needed

# APIM variables
$ApiManagementName = "translator-apim-vwuif"
$PublisherEmail = "memiset@hotmail.com"
$PublisherName = "msft"