resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = data.aws_ssm_parameter.vpc.value
  peer_vpc_id = data.aws_ssm_parameter.vpc_peer.value

  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = var.region_peer

  auto_accept = false # using aws_vpc_peering_connection_accepter

  tags = merge(
    {
      Name = format("VPC Peering between %s and %s", var.region, var.region_peer)
      Side = "Requester"
    },
    var.common_tags
  )
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = merge(
    {
      Name = format("VPC Peering between %s and %s", var.region, var.region_peer)
      Side = "Accepter"
    },
    var.common_tags
  )
}

resource "aws_vpc_peering_connection_options" "requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.peer,
    aws_vpc_peering_connection_accepter.peer
  ]
}


resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection.peer,
    aws_vpc_peering_connection_accepter.peer
  ]
}
