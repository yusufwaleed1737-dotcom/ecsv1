variable "vpc_cidr" {
    description= "CIDR block for the VPC"
    type = string
}

variable "vpc_name" {
    description= "Name tag for the VPC"
    type = string
}

variable "publicsubnet1_az" {
    description= "Availability Zone for Public Subnet 1"
    type = string
}

variable "publicsubnet2_az" {
    description = "Availability zone for Public Subnet 2"
    type = string
}

variable "privatesubnet1_az" {
    description = "Availability zone for Private Subnet 1"
    type = string
}

variable "privatesubnet2_az" {
    description = "Availability zone for Private Subnet 2"
    type = string
}

variable "public1_cidr" {
    description = "CIDR block for Public Subnet 1"
    type = string
}

variable "public2_cidr" {
    description = "CIDR block for Public Subnet 2"
    type = string
}

variable "private1_cidr" {
    description = "CIDR block for Private Subnet 1"
    type = string
}

variable "private2_cidr" {
    description = "CIDR block for Private Subnet 2"
    type = string
}

variable "domain_name" {
    description = "The domain name for the application"
    type = string
}


variable "app_domain" {
    description = "The application domain name"
    type = string
}

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