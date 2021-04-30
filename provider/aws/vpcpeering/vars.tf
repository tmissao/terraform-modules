variable "vpc_peering_name" { type = string }
variable "peer_access_key"  { type = string }
variable "peer_secret_key"  { type = string }
variable "aws_peer_region"  { type = string }
variable "vpc_requester_id" { type = string }
variable "vpc_accepter_id"  { type = string }
variable "peering_allow_dns_resolution" { default = false }
variable "create_peering_public_route_on_requester_vpc"  { default = false }
variable "create_peering_private_route_on_requester_vpc" { default = false }
variable "requester_vpc_public_route"  { default = null }
variable "requester_vpc_private_route" { default = null }
variable "create_peering_public_route_on_accepter_vpc"  { default = false }
variable "create_peering_private_route_on_accepter_vpc" { default = false }
variable "accepter_vpc_public_route"  { default = null }
variable "accepter_vpc_private_route" { default = null }
variable "tags_shared" {
  type = "map"
  default = {
    "Owner"        = "System Team"
    "ConfiguredBy" = "System Team"
    "Environment"  = "Dev"
    "Terraform"    = "true"
  }
}
