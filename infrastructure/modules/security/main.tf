resource "aws_security_group" "alb" {
    name        = "ALB Security Group"
    description = "Security group for ALB"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow HTTPS traffic"
        from_port   = var.https_port
        to_port     = var.https_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        description = "Allow HTTP traffic (redirect to HTTPS)"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {

        description = "Allow all outbound traffic"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        security_groups = [aws_security_group.tasks.id ]
    }
}

resource "aws_security_group_rule" "tasks_from_alb" {
    type = "ingress"
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    security_group_id = aws_security_group.tasks.id
    source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "tasks" {
    name = "ECS Tasks Security Group"
    description = "Security group for ECS Tasks"
    vpc_id = var.vpc_id

    egress {
        description = "Allow all outbound traffic HTTPS"
        from_port = var.https_port
        to_port = var.https_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
        description = "Allow all outbound traffic HTTP"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}