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

 all_locations = concat(var.user_location, var.default_location)
 unique_locations = toset(local.all_locations)

 positive_cost = [for cost in var.monthly_costs : abs(cost)]
 max_cost = max(local.positive_cost...)
 min_cost = min(local.positive_cost...)
 total_cost = sum(local.positive_cost)
 average_cost = local.total_cost / length(local.positive_cost)

 current_timestamp = timestamp()
 formart1 = formatdate("YYYY-MM-DD", local.current_timestamp)
 formart2 = formatdate("yyyyMMdd", local.current_timestamp)

 timestamp_name =  "backup-${local.formart1}"

 config_file_exists = fileexists("C:/Users/maxycomppoint/Downloads/Documents/AWS_TF/config.json")
 config_data = local.config_file_exists ? jsondecode(file("C:/Users/maxycomppoint/Downloads/Documents/AWS_TF/config.json")) : {}
 }

resource "aws_s3_bucket" "bucketS3" {
  bucket = "${local.format_bucket_name}"
  tags = local.tags
  
}