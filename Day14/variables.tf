variable "environment" {
  default = "Dev"
  type = string
}

variable "region" {
  default = "us-east-1"
  type = string
}
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type = number 
}

variable "monitoring_enabled" {
  description = "Enable monitoring for EC2 instances"
  type = bool
  default = true
}

variable "associate_public_ip_address" {
  description = "Associate public IP address with EC2 instances"
  type = bool
  default = true
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = set(string)
  default = [ "10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/24"]
}

variable "allowed_instance_type" {
   description = "List of allowed VMs"
   type = list(string)
   default = [ "t2.micro","t2.small", "t3.micro", "t3.small" ]
}
variable "allowed_region" {
   description = "List of allowed regions"
   type = set(string)
   default = [ "us-east-1", "us-west-2", "eu-west-1", "eu-west-2"]
}
variable "tags" {
  description = "Tags to apply to resources"
  type = map(string)
  default = {
    Environment = "Dev"
    name        = "Dev-Instance"
    Project     = "TerraformDemo"
  }
}

# variable "ingress_values"{
#   type = tuple([number, string, number])
#   default = [443, "tcp", 443]
# }

variable "ingress_values"{
  type = list(object({
    from_port   = number
    protocol    = string
    to_port     = number
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
  ] 
}

variable "config"{
  type = object({
    instance_count = number
    monitoring_enabled = bool
    associate_public_ip_address = bool
    allowed_instance_type = list(string)
    allowed_region = set(string)
  })
  default = {
    instance_count = 1
    monitoring_enabled = true
    associate_public_ip_address = true
    allowed_instance_type = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
    allowed_region = ["us-east-1", "us-west-2", "eu-west-1", "eu-west-2"]

  }
}

variable "bucket_name"{
  default = "brio-dev-demobucket23"
}

variable "bucket_name_set"{
  type = set(string)
  default = ["brio-dev-demobucket123", "brio-dev-demobucket234"]
}