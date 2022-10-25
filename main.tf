resource "aws_vpc" "btc-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Dev"
  }
}

resource "aws_internet_gateway" "btc_internet_gateway" {
  vpc_id = aws_vpc.btc-vpc.id
  
   tags = {
    Name = "Dev"
  }
}