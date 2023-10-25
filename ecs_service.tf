resource "aws_ecs_service" "ecs_service" {
  name          = "ECS_Service_1"
  cluster       = aws_ecs_cluster.ecs_cluster.id
  desired_count = var.desired_count

  launch_type = "EC2"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx-container" # Name of the container in the task definition
    container_port   = 80
  }
}
