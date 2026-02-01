resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.deployment_id != "" ? "${var.ecs_cluster_name}-${var.deployment_id}" : var.ecs_cluster_name

    setting {
        name = "containerInsights"
        value = "enabled"
    }

    tags = {
        Name = var.deployment_id != "" ? "${var.ecs_cluster_name}-${var.deployment_id}" : var.ecs_cluster_name
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = var.deployment_id != "" ? "${var.ecs_cluster_name}-task-execution-role-${var.deployment_id}" : "${var.ecs_cluster_name}-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = var.deployment_id != "" ? "${var.ecs_cluster_name}-task-execution-role-${var.deployment_id}" : "${var.ecs_cluster_name}-task-execution-role"
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
    name = var.deployment_id != "" ? "/ecs/${var.ecs_cluster_name}-${var.deployment_id}" : "/ecs/${var.ecs_cluster_name}"
    retention_in_days = 7

    tags = {
        Name = var.deployment_id != "" ? "${var.ecs_cluster_name}-log-group-${var.deployment_id}" : "${var.ecs_cluster_name}-log-group"
    }
}

resource "aws_ecs_task_definition" "ecs_task" {
    family = var.deployment_id != "" ? "${var.ecs_cluster_name}-task-def-${var.deployment_id}" : "${var.ecs_cluster_name}-task-def"
    cpu = var.ecs_task_cpu
    memory = var.ecs_task_memory

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }

    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn  
    container_definitions = jsonencode([
        {
            name = "threat-modelling-app-container"
            image = var.ecr_repository_url
            essential = true

            command = ["nginx", "-g", "daemon off;"]
            portMappings = [
                {
                    containerPort = 80
                    hostPort = 80
                    protocol = "tcp"
                }
            ]

            healthCheck = {
                command = ["CMD-SHELL", "curl -f http://localhost/health.json || exit 1"]
                interval = 30
                timeout = 5
                retries = 3
                startPeriod = 60
            }

            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group = aws_cloudwatch_log_group.ecs_logs.name
                    awslogs-region = var.aws_region
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ])
}

resource "aws_ecs_service" "threat_modelling_service" {
    name = var.deployment_id != "" ? "${var.ecs_cluster_name}-service-${var.deployment_id}" : "${var.ecs_cluster_name}-service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task.arn
    desired_count = 2
    launch_type = "FARGATE"

    network_configuration {
        subnets = var.privatesubnet_ids
        security_groups = [var.tasks_security_group_id]
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.alb_tg_arn
        container_name = "threat-modelling-app-container"
        container_port = 80
    }

    depends_on = [var.https_listener_arn]

    tags = {
        Name = var.deployment_id != "" ? "${var.ecs_cluster_name}-service-${var.deployment_id}" : "${var.ecs_cluster_name}-service"
    }
}