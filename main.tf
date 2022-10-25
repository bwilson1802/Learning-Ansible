resource "random_id" "random" {
  byte_length = 2
}

resource "aws_vpc" "btc-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Dev-${random_id.random.dec}"
  }
}

resource "aws_internet_gateway" "btc_internet_gateway" {
  vpc_id = aws_vpc.btc-vpc.id
  
   tags = {
    Name = "Dev${random_id.random.dec}"
  }
}