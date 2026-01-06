variable "vpc_cidr" {
    description= "CIDR block for the VPC"
    type = string
    default = "172.17.0.0/16"
}

variable "vpc_name" {
    description= "Name tag for the VPC"
    type = string
    default = "main"

}

variable "publicsubnet1_az" {
    description= "Availability Zone for Public Subnet 1"
    type = string
    default = "eu-west-2a"
}

variable "publicsubnet2_az" {
    description = "Availability zone for Public Subnet 2"
    type = string
    default = "eu-west-2b"
}

variable "privatesubnet1_az" {
    description = "Availability zone for Private Subnet 1"
    type = string
    default = "eu-west-2a"
}

variable "privatesubnet2_az" {
    description = "Availability zone for Private Subnet 2"
    type = string
    default = "eu-west-2b"
}

variable "public1_cidr" {
    description = "CIDR block for Public Subnet 1"
    type = string
    default = "172.17.1.0/24"
}

variable "public2_cidr" {
    description = "CIDR block for Public Subnet 2"
    type = string
    default = "172.17.2.0/24"

}

variable "private1_cidr" {
    description = "CIDR block for Private Subnet 1"
    type = string
    default = "172.17.10.0/24"
}

variable "private2_cidr" {
    description = "CIDR block for Private Subnet 2"
    type = string
    default = "172.17.20.0/24"

}

variable "domain_name" {
    description = "The domain name for the application"
    type = string
    default = "*.yusufwaleed.co.uk"
}


variable "app_domain" {
    description = "The application domain name"
    type = string
    default = "ecs.yusufwaleed.co.uk"
}

variable "ecs_cluster_name" {
    description = "The name of the ECS cluster"
    type = string
    default = "ECS-Cluster"
}


variable "ecs_task_cpu" {
    description = "The CPU units for the ECS task"
    type = string
    default = "256"
}

variable "ecs_task_memory" {
    description = "The memory for the ECS task"
    type = string
    default = "512"
}

variable "ecr_repository_url" {
    description = "The Docker image for the application"
    type = string
    default = "261916864692.dkr.ecr.eu-west-2.amazonaws.com/threat-modelling-app:v2"
}

variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
    default = "eu-west-2"
}

variable "deployment_id" {
    description = "Unique identifier for the deployment"
    type = string
    default = "v3"
}