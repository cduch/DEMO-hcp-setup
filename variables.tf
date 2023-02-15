variable "hcp_client_id" {
    description = "The HCP Client ID"
    type = string
    sensitive = false
}

variable "hcp_client_secret" {
    description = "The HCP Client Secret (sensitive)"
    type = string
    sensitive = true
}
