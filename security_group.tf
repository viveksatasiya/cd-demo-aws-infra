resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.ecs_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CD_DEMO_ECS_SG_${terraform.workspace}"
  }
}
