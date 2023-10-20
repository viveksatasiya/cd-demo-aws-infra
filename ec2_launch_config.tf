resource "aws_launch_configuration" "ecs" {
  name_prefix          = "cd-demo-ecs-launch-config-${terraform.workspace}"
  image_id             = var.ec2_ami_id
  instance_type        = var.ec2_instance_type
  security_groups      = [aws_security_group.ecs_instances_sg.id]
  key_name             = "demoall"
  iam_instance_profile = "ecsInstanceRole"

  # ECS-optimized AMI comes with AWS recommended settings.
  # Just need to set ECS_CLUSTER environment variable.
  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name}_${terraform.workspace} >> /etc/ecs/ecs.config
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_instances_sg" {
  name        = "cd-demo-${terraform.workspace}-ecs-instances-sg"
  description = "Security group for ECS instances"
  vpc_id      = aws_vpc.ecs_vpc.id

  # Allow incoming traffic from ALB
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 32768
    to_port         = 61000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "cd-demo-${terraform.workspace}-ecs-instances-sg"
    Environment = terraform.workspace
  }
}

