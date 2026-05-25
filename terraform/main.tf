terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket = "bedrock-tfstate-ifhy1"
    key    = "project-bedrock/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}