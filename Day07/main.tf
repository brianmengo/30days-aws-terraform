
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "name" {
  count = var.instance_count
  ami = "ami-0c1e21d82fe9c9336"
  instance_type = var.allowed_instance_type[2]
  region = tolist(var.allowed_region)[1]

  monitoring = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip_address

  tags = var.tags
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[1]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

