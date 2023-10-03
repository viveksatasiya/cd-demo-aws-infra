resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CD_DEMO_ECS_VPC_${terraform.workspace}"
  }
}
