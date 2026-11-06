variable "project_name" {
  description = "Short project name used to identify resources"
  type        = string
  default     = "homework-iac"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Person or team responsible for the resources"
  type        = string
  default     = "student"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "your_name" {
  description = "Name displayed on the web page"
  type        = string
  default     = "David Mayorga"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AWS availability zone for the public subnet"
  type        = string
  default     = "us-east-2a"
}