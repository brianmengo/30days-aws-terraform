terraform{
    backend "s3" {
    bucket = "brio-dev-demobucket"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
    }
}