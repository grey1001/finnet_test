module "s3_auth" {
  source = "../modules/s3"
  bucket_name = var.bucket_auth
  source_file = "./auth.html"
  key = "auth.html"
  tags = var.bucket_tags
}

module "s3_info" {
  source = "../modules/s3"
  bucket_name = var.bucket_info
  key = "info.html"
  source_file = "./info.html"
  tags = var.bucket_tags
}

module "s3_customers" {
  source = "../modules/s3"
  bucket_name = var.bucket_customers
  key = "customers.html"
  source_file = "./customers.html"
  tags = var.bucket_tags
}



resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name = "Cloudfront s3 OAC_auth"
  origin_access_control_origin_type = "s3"
  signing_protocol = "sigv4"
  signing_behavior = "always"
}


resource "aws_cloudfront_distribution" "cloudfront_distrib" {
  depends_on = [
    module.s3_auth,
    aws_cloudfront_origin_access_control.cloudfront_s3_oac
  ]

  origin {
    domain_name = module.s3_auth.s3_bucket.bucket_regional_domain_name
    origin_id   =  module.s3_auth.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  }

  enabled = true

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = module.s3_auth.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_root_object = "./auth.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_auth" {
  bucket = module.s3_auth.s3_bucket_id
  policy = data.aws_iam_policy_document.bucket_auth.json
}

data "aws_iam_policy_document" "bucket_auth" {
  depends_on = [
    aws_cloudfront_distribution.cloudfront_distrib,
    module.s3_auth
  ]

  statement {
    
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${module.s3_auth.s3_bucket_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distrib.arn]
    }
  }
}



################ for bucket_info

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac_info" {
  name = "Cloudfront s3 OAC_info"
  origin_access_control_origin_type = "s3"
  signing_protocol = "sigv4"
  signing_behavior = "always"
}


resource "aws_cloudfront_distribution" "cloudfront_distrib_info" {
  depends_on = [
    module.s3_info,
    aws_cloudfront_origin_access_control.cloudfront_s3_oac_info
  ]

  origin {
    domain_name = module.s3_info.s3_bucket.bucket_regional_domain_name
    origin_id   =  module.s3_info.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac_info.id
  }

  enabled = true

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = module.s3_info.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_root_object = "./info.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_info" {
  bucket = module.s3_info.s3_bucket_id
  policy = data.aws_iam_policy_document.bucket_info.json
}

data "aws_iam_policy_document" "bucket_info" {
  depends_on = [
    aws_cloudfront_distribution.cloudfront_distrib_info,
    module.s3_info
  ]

  statement {
    
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${module.s3_info.s3_bucket_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distrib_info.arn]
    }
  }
}



######### for bucket_customers

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac_customers" {
  name = "Cloudfront s3 OAC_customers"
  origin_access_control_origin_type = "s3"
  signing_protocol = "sigv4"
  signing_behavior = "always"
}


resource "aws_cloudfront_distribution" "cloudfront_distrib_customers" {
  depends_on = [
    module.s3_customers,
    aws_cloudfront_origin_access_control.cloudfront_s3_oac_customers
  ]

  origin {
    domain_name = module.s3_customers.s3_bucket.bucket_regional_domain_name
    origin_id   =  module.s3_customers.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac_customers.id
  }

  enabled = true

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = module.s3_customers.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_root_object = "./customers.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_customers" {
  bucket = module.s3_customers.s3_bucket_id
  policy = data.aws_iam_policy_document.bucket_customers.json
}

data "aws_iam_policy_document" "bucket_customers" {
  depends_on = [
    aws_cloudfront_distribution.cloudfront_distrib_customers,
    module.s3_customers
  ]

  statement {
    
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${module.s3_customers.s3_bucket_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distrib_customers.arn]
    }
  }
}


