terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
#Create S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "devbrio53-store"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}