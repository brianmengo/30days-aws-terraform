terraform {
   
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider

variable "environment" {
  default = "dev"
  
}

variable "region" {
  default = "us-east-1"
}

locals {
   bucket_name = "brio-store-${var.environment}"
  vpc_name = "${var.environment}-VPC"
}
#Create S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}
resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  region = var.region
  tags = {
    Environment = var.environment
    Name = local.vpc_name
  }
}

resource "aws_instance" "name" {
  ami = "ami-0c1e21d82fe9c9336"
  instance_type ="t2.micro"
  region = var.region

  tags = {
    Environment = "Dev"
    Name = "${var.environment}-instance"
  }
}

output "vpc_id" {
  value = aws_vpc.sample.id
}

output "ec2_id" {
  value = aws_instance.name.id
}