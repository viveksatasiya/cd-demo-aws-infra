resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.task_family}_${terraform.workspace}"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = jsonencode([{
    name  = "nginx-container"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80
      hostPort      = 0
    }]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ECS_Service_1"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.desired_count

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
