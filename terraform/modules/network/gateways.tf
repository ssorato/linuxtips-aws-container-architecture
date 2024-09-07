resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = format("igw-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_eip" "natgw_eip" {
  domain = "vpc"

  tags = merge(
    {
      Name = format("elastic-ip-nat-gw-%s", var.project_name)
    },
    var.common_tags
  )
}

#
# NAT gateway must be created in the public subnet
# This is a point of failure
# Saving money using one nat gateway
#
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    {
      Name = format("nat-gw-%s", var.project_name)
    },
    var.common_tags
  )
}
