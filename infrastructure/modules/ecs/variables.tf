variable "ecs_cluster_name" {
    description = "The name of the ECS cluster"
    type = string
}


variable "ecs_task_cpu" {
    description = "The CPU units for the ECS task"
    type = string
}

variable "ecs_task_memory" {
    description = "The memory for the ECS task"
    type = string
}

variable "ecr_repository_url" {
    description = "The Docker image for the application"
    type = string
}

variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
}

variable "privatesubnet_ids" {
    description = "List of private subnet IDs"
    type = list(string)
}

variable "tasks_security_group_id" {
    description = "Security group ID for ECS tasks"
    type = string
}

variable "alb_tg_arn" {
    description = "The ARN of the ALB target group"
    type = string
}

variable "https_listener_arn" {
    description = "The ARN of the HTTPS listener"
    type = string
}

variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
  default     = ""
}