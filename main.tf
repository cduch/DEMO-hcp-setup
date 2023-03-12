


# hvn

resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = "172.25.16.0/20"
}


# aws peering

resource "aws_vpc" "peer" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "HCP-Demo"
  }

}


resource "aws_route_table" "route" {
  vpc_id = aws_vpc.peer.id

  route {
    cidr_block = hcp_hvn.hvn.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.vpc_peering_connection_id
  }

  tags = {
    Name = "aws-to-hvn"
  }
}



resource "hcp_aws_network_peering" "peer" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  peering_id      = var.peering_id
  peer_vpc_id     = aws_vpc.peer.id
  peer_account_id = aws_vpc.peer.owner_id
  peer_vpc_region = var.region
}

resource "hcp_hvn_route" "peer_route" {
  hvn_link         = hcp_hvn.hvn.self_link
  hvn_route_id     = var.route_id
  destination_cidr = aws_vpc.peer.cidr_block
  target_link      = hcp_aws_network_peering.peer.self_link
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
  auto_accept               = true
}


# HCP consul

resource "hcp_consul_cluster" "consul_cluster" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  cluster_id      = var.cluster_id
  tier            = "development"
  public_endpoint = true
}


# consul security group


resource "aws_security_group" "allowconsul" {
  name        = "Allow_Consul"
  description = "Allow Consul inbound and outbound traffic"
  vpc_id      = aws_vpc.peer.id

  ingress {
    description = "Used to handle gossip from server"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  ingress {
    description = "Used to handle gossip from server"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  ingress {
    description = "Used to handle gossip between client agents"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Used to handle gossip between client agents"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    self        = true
  }


  egress {
    description = "For RPC communication between clients and servers"
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  egress {
    description = "Used to gossip with server"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  egress {
    description = "Used to gossip with server"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  egress {
    description = "Used to gossip between client agents"
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Used to gossip between client agents"
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    self        = true
  }


  egress {
    description = "The HTTP API"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  egress {
    description = "The HTTPS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }

  tags = {
    Name = "allow_consul"
  }
}



#vault

resource "hcp_vault_cluster" "vault" {
  cluster_id = "vault-cluster"
  hvn_id     = hcp_hvn.hvn.hvn_id
  tier       = "starter_small"
  public_endpoint = true
}

# vault security group




resource "aws_security_group" "allowvault" {
  name        = "Allow_Vault"
  description = "Allow Vault outbound traffic"
  vpc_id      = aws_vpc.peer.id

  egress {
    description = "The HTTPS API"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.hvn.cidr_block]
  }


  tags = {
    Name = "allow_vault"
  }
}
