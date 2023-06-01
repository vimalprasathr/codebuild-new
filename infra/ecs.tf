
resource "aws_ecs_cluster" "dev-backend" {
  name = "xyz-backend-dev"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "backend" {
  name            = "xyz-dev-backend-svc"
  cluster         = aws_ecs_cluster.dev-backend.id
  task_definition = aws_ecs_task_definition.dev_backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.dev_backend_task.id]
    subnets         = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.id
    container_name   = var.ecs_container_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.backend]
}

resource "aws_ecs_task_definition" "dev_backend" {
  family                   = "xyz-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = module.ecs-execution-role.ecs_role_arn

  container_definitions = <<DEFINITION
[
  {
    "image": "714732271094.dkr.ecr.us-east-1.amazonaws.com/xyz-dev-backend:latest",
    "cpu": 500,
    "memory": 1024,
    "name": "${var.ecs_container_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/xyz-dev-backend",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "secrets": [
      {
        "name": "USER_NAME",
        "valueFrom": "${aws_secretsmanager_secret_version.ecsbackend.arn}"
      }
    ],
    "environment": []
  }
]
DEFINITION
}

module "ecs-execution-role" {
  source  = "aisamji/ecs-execution-role/aws"
  version = "1.0.0"
}

# Autoscaling
resource "aws_appautoscaling_target" "to_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.dev-backend.name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "to_memory" {
  name               = "to-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "to_cpu" {
  name               = "to-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
