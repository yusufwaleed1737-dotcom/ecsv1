variable "app_domain" {
    description = "The application domain name"
    type = string
}

variable "alb_security_group_id" {
    description = "Security group IDs for the ALB"
    type = list(string)
}

variable "publicsubnet_ids" {
    description = "List of public subnet IDs for the ALB"
    type = list(string)
}

variable "logs_bucket_name" {
    description = "The S3 bucket name for ALB access logs"
    type = string
}

variable "vpc_id" {
    description = "The VPC ID where the ALB will be deployed"
    type = string
}

variable "aws_certificate_arn" {
    description = "The ARN of the ACM certificate for HTTPS"
    type = string
}

variable "route_53_zone_id" {
    description = "The Route 53 Hosted Zone ID for the domain"
    type = string
}

variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
  default     = ""
}