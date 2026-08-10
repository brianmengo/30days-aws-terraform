resource "aws_s3_bucket" "S3private"{
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.S3private.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = "Demo-OAC"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "allow_cf_access" {
  bucket = aws_s3_bucket.S3private.id
  depends_on = [aws_s3_bucket_public_access_block.block]

  policy = jsonencode({

    "Statement" : [{
      "Sid"      : "AllowCloudFrontServicePrincipal",
      "Effect"   : "Allow",
      "Principal" : {
        "Service"     : "cloudfront.amazonaws.com"
      },
      "Action" : [
        "s3:GetObject",
        ],
      "Resource"  : "${aws_s3_bucket.S3private.arn}/*"
      "Condition" = {
        "StringEquals" = {
          "AWS:SourceArn": "aws_cloudfront_distribution.s3_distribution.arn"
        }
      }
      
    }]
    "Version" = "2012-10-17"
})

}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.S3private.id
  for_each = fileset("C:\\Users\\maxycomppoint\\Downloads\\Documents\\AWS_TF\\Day14\\www", "**/*")
  key    = each.value
  source = "C:\\Users\\maxycomppoint\\Downloads\\Documents\\AWS_TF\\Day14\\www\\${each.value}"
  etag = filemd5("C:\\Users\\maxycomppoint\\Downloads\\Documents\\AWS_TF\\Day14\\www\\${each.value} ")
  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.S3private.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

viewer_certificate {
    cloudfront_default_certificate = true
  }
}

