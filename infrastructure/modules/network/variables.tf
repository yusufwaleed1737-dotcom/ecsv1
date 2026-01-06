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

