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
    Name = "dev-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "btc_internet_gateway" {
  vpc_id = aws_vpc.btc-vpc.id

  tags = {
    Name = "dev${random_id.random.dec}"
  }
}

resource "aws_route_table" "btc-public-route" {
  vpc_id = aws_vpc.btc-vpc.id

  tags = {
    Name = "dev"
  }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.btc-public-route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.btc_internet_gateway.id
}

resource "aws_default_route_table" "btc-private-route-table" {
  default_route_table_id = aws_vpc.btc-vpc.default_route_table_id

  tags = {
    Name = "dev"
  }
} 

resource "aws_subnet" "btc-public-subnet" {
  count = 2
  vpc_id     = aws_vpc.btc-vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dev-${count.index + 1}"
  }
}