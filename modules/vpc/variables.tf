variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of Availability Zones to use"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
