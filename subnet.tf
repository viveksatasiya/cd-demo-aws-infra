data "aws_availability_zones" "current" {}
resource "aws_subnet" "ecs_subnet" {
  count = length(var.subnet_cidrs)

  cidr_block              = var.subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.ecs_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.current.names[count.index]

  tags = {
    Name = "CD_DEMO_ECS_Subnet_${count.index}_${terraform.workspace}"
  }
}
