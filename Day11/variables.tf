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