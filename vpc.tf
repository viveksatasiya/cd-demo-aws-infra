resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CD_DEMO_ECS_VPC_${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "ecs_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "cd-demo-igw-${terraform.workspace}"
  }
}


resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.ecs_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs_gateway.id
}
