locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length = 2
}

resource "aws_vpc" "btc-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "dev-vpc-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "btc_internet_gateway" {
  vpc_id = aws_vpc.btc-vpc.id

  tags = {
    Name = "dev-gateway-${random_id.random.dec}"
  }
}

resource "aws_route_table" "btc-public-route" {
  vpc_id = aws_vpc.btc-vpc.id

  tags = {
    Name = "dev-pub-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.btc-public-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.btc_internet_gateway.id

}

resource "aws_default_route_table" "btc-private-route-table" {
  default_route_table_id = aws_vpc.btc-vpc.default_route_table_id

  tags = {
    Name = "dev-pvt-rt-table"
  }
}

resource "aws_subnet" "btc-public-subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.btc-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dev-pub-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "btc-private-subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.btc-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, length(local.azs) + count.index)
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dev-pvt-sub-${count.index + 1}"
  }
}

resource "aws_route_table_association" "btc-public-assoc" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.btc-public-subnet[count.index].id
  route_table_id = aws_route_table.btc-public-route.id
}

resource "aws_security_group" "btc-sg" {
  name        = "public-sg"
  description = "security group for public instances"
  vpc_id      = aws_vpc.btc-vpc.id
}

resource "aws_security_group_rule" "ingress-all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip]
  security_group_id = aws_security_group.btc-sg.id
}

resource "aws_security_group_rule" "egress-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip]
  security_group_id = aws_security_group.btc-sg.id
}