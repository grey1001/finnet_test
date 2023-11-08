resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}



resource "aws_s3_object" "object" {
  bucket       = var.bucket_name
  key          = var.key
  
  source       = var.source_file #"object/index.html"
  content_type = "text/html"

  etag = filemd5(var.source_file)
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}


resource "aws_s3_bucket_acl" "aws_s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}


resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "aws_s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }


resource "aws_s3_bucket_server_side_encryption_configuration" "aws_s3_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
     sse_algorithm     = "AES256"
    }
  }
}