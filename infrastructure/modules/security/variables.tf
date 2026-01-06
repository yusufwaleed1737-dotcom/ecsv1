variable "http_port"  {
    description = "The port for HTTP traffic"
    type        = number
    default     = 80
}

variable "https_port"  {
    description = "The port for HTTPS traffic"
    type        = number
    default     = 443
}

variable "vpc_id" {
    description = "The ID of the VPC where SGs will be created"
    type = string
}