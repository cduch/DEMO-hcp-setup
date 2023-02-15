provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}


# Create HVN on HCP

resource "hcp_hvn" "mainhvn" {
  hvn_id         = "main-hvn"
  cloud_provider = "aws"
  region         = "eu-central-1"
  cidr_block     = "172.25.16.0/20"
}


# TODO: create Peering to AWS
