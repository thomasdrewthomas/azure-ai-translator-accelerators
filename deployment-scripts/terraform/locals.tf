locals {
  name_prefix = "${var.prefix}${var.name}-${var.environment}"


  default_tags = {
    Region      = var.location
    Environment = var.environment
    Owner       = "AI-TEAM"
    Project     = "AI-TRANSLATOR"
    Stage       = "TRANSLATION-SERVICE"
    ManagedBy   = "TERRAFORM"
    CostCenter  = "AI-TEAM"
  }
}
