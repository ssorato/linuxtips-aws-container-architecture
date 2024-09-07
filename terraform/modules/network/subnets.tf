resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.region_azones.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format("private-subnet-vpc-%s-%s", var.project_name, data.aws_availability_zones.region_azones.names[count.index])
    },
    var.common_tags
  )
}

resource "aws_route_table" "private_internet_access" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = format("private-route-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_route" "private_access" {
  route_table_id         = aws_route_table.private_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  route_table_id = aws_route_table.private_internet_access.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.region_azones.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format("public-subnet-vpc-%s-%s", var.project_name, data.aws_availability_zones.region_azones.names[count.index])
    },
    var.common_tags
  )
}

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = format("public-route-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_route" "public_access" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public_subnet)

  route_table_id = aws_route_table.public_internet_access.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}


resource "aws_subnet" "database_subnet" {
  count                   = length(var.databases_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.databases_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.region_azones.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format("databases-subnet-vpc-%s-%s", var.project_name, data.aws_availability_zones.region_azones.names[count.index])
    },
    var.common_tags
  )
}
