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
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ECS_Service_1"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.desired_count

  launch_type = "EC2"

  network_configuration {
    subnets = aws_subnet.ecs_subnet.*.id
  }
}
