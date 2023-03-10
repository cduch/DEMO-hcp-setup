variable "hcp_client_id" {
  description = "The HCP Client ID"
  type        = string
  sensitive   = false
}

variable "hcp_client_secret" {
  description = "The HCP Client Secret (sensitive)"
  type        = string
  sensitive   = true
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "route_id" {
  type    = string
  default = "hvn-to-aws"
}

variable "peering_id" {
  type    = string
  default = "hvn"
}

variable "cluster_id" {
  type    = string
  default = "consul"
}

variable "hvn_id" {
  type    = string
  default = "hvn"

}
