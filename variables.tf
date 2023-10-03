variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "ECS task family name"
  type        = string
}

variable "desired_count" {
  description = "Desired count of tasks in ECS service"
  type        = number
}


variable "ec2_ami_id" {
  description = "ECS optimized AMI ID"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for ECS nodes"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}

variable "task_memory" {
  description = "The amount of memory to allow the task to use"
}

variable "task_cpu" {
  description = "The amount of CPU to allow the task to use"
}
