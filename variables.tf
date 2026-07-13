
# core

# variable "account" {
#   description = "The AWS Account Number (10 digit) to create resources in."
#   #default     = "1234567890" # Replace with account number or input on the terminal
# }

variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-west-3"
}


# networking

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}


# load balancer

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/"
}

# variable "amis" {
#   description = "Which AMI to spawn."
#   default = {
#     us-east-1 = "ami-05fa00d4c63e32376"
#     us-east-2 = "ami-0568773882d492fc8"
#   }
# }

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  default     = "benjaminfiche"
}

variable "bastion_instance_name" {
  description = "Name of the Bastion instance"
  default     = "benjaminfiche"
}

# key pair - Location to the SSH Key generate using openssl or ssh-keygen or AWS KeyPair
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
#   default     = "~/.ssh/aws/aws_key.pub"
}


# auto scaling

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "2"
}

variable "autoscale_bastion_min" {
  description = "Minimum autoscale (number of Bastion)"
  default     = "2"
}
variable "autoscale_bastion_max" {
  description = "Maximum autoscale (number of Bastion)"
  default     = "2"
}
variable "autoscale_bastion_desired" {
  description = "Desired autoscale (number of Bastion)"
  default     = "2"
}

variable "provider_username" {
type = string
description = "AWS Account"
sensitive = true
}

variable "provider_password" {
type = string
description = "AWS password"
sensitive = true
}