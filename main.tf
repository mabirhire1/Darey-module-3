terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "ecr" {
  source = "./modules/ecr"
  
  repository_name = "${var.project_name}-${var.environment}"
  
  tags = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"
  
  cluster_name        = "${var.project_name}-${var.environment}-cluster"
  service_name        = "${var.project_name}-${var.environment}-service"
  ecr_repository_url  = module.ecr.repository_url
  
  depends_on = [module.ecr]
}
