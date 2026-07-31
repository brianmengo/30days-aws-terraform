locals {
  formatted_project_name = lower(replace(var.project_name, " ", ""))
  tags = merge(var.default_tags, var.environment_tag)
  format_bucket_name = replace(replace(lower(substr(var.bucket_name, 0, 63)), " ", "")
  ,"!","")

  port_list = split(",", var.allowed_ports)

  sg_rules = [
    for port in local.port_list : {
      name        = "AllowPort ${(port)}"
      port        = port
      description = "Allow Traffic on port ${(port)}"
    }
  ]
 
 instance_sizes = lookup(var.instance_size, var.environment, "t3.large")
}

resource "aws_s3_bucket" "bucketS3" {
  bucket = "${local.format_bucket_name}"
  tags = local.tags
  
}