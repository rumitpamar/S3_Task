
resource "aws_s3_bucket" "mytaskbucket1" {
  bucket = var.bucket_name

}
resource "aws_s3_bucket_policy" "mytaskbucket1_policy" {
  bucket = aws_s3_bucket.mytaskbucket1.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.mytaskbucket1.id}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.mytaskbucket1.arn}/*"
    }
  ]
}
EOF
}
resource "aws_s3_bucket_lifecycle_configuration" "mytaskbucket1" {
  bucket = aws_s3_bucket.mytaskbucket1.id

  rule {
    id     = "archive-after-30-days"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = var.storage_class_name
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "mytaskbucket1" {
  name   = "mytaskbucket1"
  bucket = aws_s3_bucket.mytaskbucket1.id

  filter {
    prefix = ""
  }

  tiering {
    days        = 180
    access_tier = var.Name_of_access_tier
  }

  ###################################################################################################################################################################################################

  # Adding here the steps where object which is not accesible out of S3 will be store into the "DEEP_ARCHIVE" tier for more cost optimization
  # Also this block is by defaulted commented here by me it'll will be uncommented if this block is require

  ###################################################################################################################################################################################################    

  # tiering {
  #   days        = 360
  #   access_tier = "DEEP_ARCHIVE"
  # }
}


###################################################################################################################################################################################################


##############  CloudFront Block  ##############

#This block is by default uncommented; however, the Cloudfront block will be helpful if the data is accessible globally.
# With CloudFront, our costs will decrease as the speed of data delivery increases.
# Our expenses will go down with CloudFront as the speed at which data is delivered rises. However, as cloudfront stores data at many edge locations, it will cost us if the data is not globally available or if it is region-specific. 

resource "aws_cloudfront_origin_access_identity" "mytaskbucket1" {
  comment = "Origin Access Identity for mytaskbucket1"
}


resource "aws_cloudfront_distribution" "mytaskbucket1" {
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  origin {
    domain_name = aws_s3_bucket.mytaskbucket1.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.mytaskbucket1.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.mytaskbucket1.cloudfront_access_identity_path
    }
  }

  enabled             = true
  comment             = "Main Project CloudFront Distribution"
  default_root_object = "index.html"

  # Viewer protocol policy settings
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = aws_s3_bucket.mytaskbucket1.id

    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = var.query_string
      cookies {
        forward = "none"
      }
    }
  }

  # these must be uncommented based on specific rquirments.
  price_class = "PriceClass_100" # Use all edge locations (best performance)
  # price_class = "PriceClass_200" # Use only North America and Europe

  # Distribution settings
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # Uncomment one of the following lines based on requirments
      # locations         = ["US", "CA", "EU"]
      # locations         = ["US", "CA", "EU", "AS", "ME", "AF"]
    }
  }
}
