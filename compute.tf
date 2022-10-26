data "aws_ami" "server-ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_id" "btc-node-id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_instance" "btc-main" {
  count         = var.main_instance_count
  instance_type = var.main_instance_type
  ami           = data.aws_ami.server-ami.id
  # key_name = 
  vpc_security_group_ids = [aws_security_group.btc-sg.id]
  subnet_id              = aws_subnet.btc-public-subnet[count.index].id
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    name = "dev-mch-${random_id.btc-node-id[count.index].dec}"
  }
}