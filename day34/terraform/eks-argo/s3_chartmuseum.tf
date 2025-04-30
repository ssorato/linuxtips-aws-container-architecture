
resource "aws_s3_object" "linuxtips" {
  bucket = module.eks-argo.s3_chartmuseum_id
  key    = "linuxtips-0.1.0.tgz"
  source = "${path.module}/../../helm/linuxtips-0.1.0.tgz"
  etag   = filemd5("${path.module}/../../helm/linuxtips-0.1.0.tgz")
}
