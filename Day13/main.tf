resource "aws_instance" "example"{
  ami           = "ami-0ff8a91507f77f867"
  # instance_type = var.allowed_instance_type[2]
  
  instance_type = var.environment == "dev" ? var.allowed_instance_type[0] : var.allowed_instance_type[2]
  tags = var.tags
  
}

resource "aws_security_group" "example" {
  name        = "sg"
  description = "Security group for example instance"
 

  dynamic "ingress" {
    for_each = var.ingress_values
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress = []

}

locals {
  all_instance_ids = aws_instance.example[*].id
}

output "instance_ids" {
  value = local.all_instance_ids
}