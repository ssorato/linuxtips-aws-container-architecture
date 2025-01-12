resource "aws_s3_bucket" "main" {
  bucket        = format("%s-%s-%s", var.bucket_prefix_name, data.aws_caller_identity.current.account_id, var.region)
  force_destroy = true

  tags = merge(
    {
      Name = format("%s", lookup(var.sqs_processing_sales_config, "queue_name"))
    },
    var.common_tags
  )
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket     = aws_s3_bucket.main.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.main]
}