data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

data "aws_vpc" "vpc_requester" {
  id = var.vpc_requester_id
}

data "aws_vpc" "vpc_accepter" {
  provider = "aws.peer"
  id = var.vpc_accepter_id
}

provider "aws" {
  alias      = "peer"
  access_key = var.peer_access_key
  secret_key = var.peer_secret_key
  region     = var.aws_peer_region
}

resource "aws_vpc_peering_connection" "peering" {
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_vpc_id   = var.vpc_accepter_id
  vpc_id        = var.vpc_requester_id
  auto_accept   = false
  peer_region   = var.aws_peer_region

  tags = "${
      merge(
        var.tags_shared,
        map( 
          "Name", var.vpc_peering_name,
        )
      ) 
  }"  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
  tags = "${
      merge(
        var.tags_shared,
        map( 
          "Name", var.vpc_peering_name,
        )
      ) 
  }"  
  lifecycle {
    ignore_changes = [tags["data-criacao"]]
  }
}

resource "aws_vpc_peering_connection_options" "requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
  requester {
    allow_remote_vpc_dns_resolution = var.peering_allow_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = "aws.peer"
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
  accepter {
    allow_remote_vpc_dns_resolution = var.peering_allow_dns_resolution
  }
}

resource "aws_route" "vpc_requester_peering_public_route" {
  count = var.create_peering_public_route_on_requester_vpc ? 1 : 0
  depends_on = [aws_vpc_peering_connection_accepter.peer]
  route_table_id            = var.requester_vpc_public_route
  destination_cidr_block    = data.aws_vpc.vpc_accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "vpc_requester_peering_private_route" {
  count = var.create_peering_private_route_on_requester_vpc ? 1 : 0
  depends_on = [aws_vpc_peering_connection_accepter.peer]
  route_table_id            = var.requester_vpc_private_route
  destination_cidr_block    = data.aws_vpc.vpc_accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "vpc_accepter_peering_public_route" {
  provider = "aws.peer"
  count = var.create_peering_public_route_on_accepter_vpc ? 1 : 0
  depends_on = [aws_vpc_peering_connection_accepter.peer]
  route_table_id            = var.accepter_vpc_public_route
  destination_cidr_block    = data.aws_vpc.vpc_requester.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "vpc_accepter_peering_private_route" {
  provider = "aws.peer"
  count = var.create_peering_private_route_on_accepter_vpc ? 1 : 0
  depends_on = [aws_vpc_peering_connection_accepter.peer]
  route_table_id            = var.accepter_vpc_private_route
  destination_cidr_block    = data.aws_vpc.vpc_requester.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}