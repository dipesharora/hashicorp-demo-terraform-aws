resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.aws_region}a"
  cidr_block        = var.web_subnet_cidr_block
}

resource "aws_internet_gateway" "inet_gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "instance_public_route" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet_all" {
  route_table_id         = aws_route_table.instance_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.inet_gw.id
}

resource "aws_route_table_association" "instance_public_route_assoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.instance_public_route.id
}

resource "aws_security_group" "web_sg" {
  name   = "web-secgrp"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Retrieve information about the HCP Packer "iteration"
data "hcp_packer_iteration" "ubuntu2204lts_iteration" {
  bucket_name = "ubuntu-2204-lts"
  channel     = "release"
}

# Retrieve information about the HCP Packer "image"
data "hcp_packer_image" "ubuntu2204lts_image" {
  bucket_name    = "ubuntu-2204-lts"
  iteration_id   = data.hcp_packer_iteration.ubuntu2204lts_iteration.id
  cloud_provider = "aws"
  region         = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami                    = data.hcp_packer_image.ubuntu2204lts_image.cloud_image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  #   associate_public_ip_address = true
  key_name = var.ssh_key_name
}

resource "aws_eip" "web_eip" {
  instance = aws_instance.webserver.id
  vpc      = true
}

output "elasticipaddress" {
  value = aws_eip.web_eip.public_ip
}

output "elasticdnsaddress" {
  value = aws_eip.web_eip.public_dns
}