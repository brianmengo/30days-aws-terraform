variable "project_name"{
  default = "Project ALPHA Resources"
}

variable "default_tags" {
  type = map(string)
  default = {
    Company = "TechCorp"
    Managed = "Terraform"
  }
}

variable "environment_tag" {
  default = {
    Environment = "production"
    cost_center = "12345"
  }
}

variable "bucket_name" {
  default = "ProjectBucketResource All CAPS with Spaces!!!"
}

variable "allowed_ports"{
  default = "22, 80, 443, 8080"
}

variable "instance_size" {
  default = {
    dev = "t2.micro"
    prod = "t2.large"
    staging = "t3.medium"
  }
}

variable "environment" {
  default = "dev"
}

variable "instance_type" {
  default = "t2.micro"

  validation {
    condition = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters."
  }

  validation{
    condition = can(regex("^t[2-3]\\.[a-z]+$", var.instance_type))
    error_message = "Instance type must start with 't2.' or 't3.' followed by a valid suffix."
  }
}

variable "credentials" {
    default ="xwy1344"
    sensitive = true
  }

variable "user_location" {
  default = ["us-east-1", "us-west-1", "us-east-1"]
}

variable "default_location" {
  default = ["us-west-2"]
}

variable "monthly_costs" {
  default = [-50, 100, 200, -150, 300]
}