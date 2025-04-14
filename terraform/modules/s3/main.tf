resource "aws_s3_bucket" "static_app_bucket" {
  bucket = "static-app-${bucket_name}"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_public_acess_block" "static_app_bucket" {
  bucket = aws_s3_bucket.static_app_bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_app_bucket" {
  bucket = aws_s3_bucket.static_app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_app_bucket" {
  depends_on = [
    aws_s3_bucket_public_access_block.static_app_bucket,
    aws_s3_bucket_ownership_controls.static_app_bucket
  ]

  bucket = aws_s3_bucket.static_app_bucket.id
  acl = "public-read"
}