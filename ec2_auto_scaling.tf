resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "cd-demo-ecs-asg-${terraform.workspace}"
  launch_configuration = aws_launch_configuration.ecs.name
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  vpc_zone_identifier  = aws_subnet.ecs_subnet.*.id
  force_delete         = true
  target_group_arns    = [aws_lb_target_group.ecs_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "cd-demo-ecs-instance-${terraform.workspace}"
    propagate_at_launch = true
  }
}
