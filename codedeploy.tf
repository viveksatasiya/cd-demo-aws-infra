resource "aws_codedeploy_app" "ecs_app" {
  name             = "cd-demo-backend-${terraform.workspace}"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
  app_name               = aws_codedeploy_app.ecs_app.name
  deployment_group_name  = "cd-demo-backend-${terraform.workspace}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = "arn:aws:iam::671939990958:role/CodeDeployServiceRole"

  ecs_service {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    service_name = aws_ecs_service.ecs_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.ecs_alb_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.ecs_tg.name
      }

      target_group {
        name = aws_lb_target_group.ecs_tg_green.name
      }
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
}
