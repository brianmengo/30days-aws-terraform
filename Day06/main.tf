
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
#Create S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = ""

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}