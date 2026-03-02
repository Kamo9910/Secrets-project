resource "aws_ecs_cluster" "cluster" {
    name = var.cluster-name
  
}

resource "aws_ecs_task_definition" "secret-task" {
    family                   = var.task-family
    execution_role_arn       = aws_iam_role.ecs_task_execution.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"

    container_definitions = jsonencode([
        {
            name      = "${var.app-name}"
            image     = "${aws_ecr_repository.weather_app.repository_url}:latest"
            portMappings = [
                {
                    containerPort = 3000
                    hostPort      = 3000
                    protocol      = "tcp"

                  
                }
            ]
        }
    ])
  
}

resource "aws_ecs_service" "secret-service" {
    name                              = var.ecs-service-name
    cluster                           = aws_ecs_cluster.cluster.id
    task_definition                   = aws_ecs_task_definition.secret-task.arn
    health_check_grace_period_seconds = 30
    desired_count                     = 1
    launch_type                       = "FARGATE"

    network_configuration {
        subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]
        security_groups = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }
  load_balancer {
    target_group_arn = aws_lb_target_group.tp.arn
    container_name   = var.app-name
    container_port   = var.container_port
  }
}