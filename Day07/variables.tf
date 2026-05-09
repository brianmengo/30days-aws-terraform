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
