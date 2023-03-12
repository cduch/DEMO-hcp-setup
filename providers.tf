terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    hcp = {
      source = "hashicorp/hcp"

    }

  }

}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
      Project     = var.project
    }
  }
}
