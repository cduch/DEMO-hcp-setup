output "hvn_id" {
  description = "HVN-ID"
  value       = hcp_hvn.mainhvn.hvn_id
}

output "hvn_cidr" {
    description = "HVN-CIDR Block"
    value = hcp_hvn.mainhvn.cidr_block
}