terraform {
  backend "s3" {
    bucket = "avesta-terraform-state"
    key    = "demo/cd-demo"
    region = "ap-south-1"
  }
}
