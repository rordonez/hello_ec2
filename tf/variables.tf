variable "ami_id" {
  description = "AMI id to use to create instances"
  type = string
}

variable "instance_type" {
  description = "Instance type for the instances"
  type = string
}

variable "availability_zones" {
  description = "Availability zones in which to deploy instances"
  type = list(string)
}

variable "desired_capacity" {
  description = "Desired number of running instances"
  type = number
}

variable "max_size" {
  description = "Maximum number of running instances"
  type = number
}

variable "min_size" {
  description = "Minimum number of running instances"
  type = number
}

variable "scaling_adjustment" {
  description = "Scale application unit when alarm is triggered"
  type = number
}

