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
  default = "dev-to-main"
}

variable "peer_id" {
  type    = string
  default = "dev"
}

variable "cluster_id" {
  type    = string
  default = "cluster"
}

variable "hvn_id" {
  type    = string
  default = "hvn"

}
