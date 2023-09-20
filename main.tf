provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-cd-demo-${terraform.workspace}"
  acl    = "private"
}
