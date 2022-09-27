variable "aws_region" {
  description = "The AWS region to deploy the EC2 instance in."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/24"
}

variable "web_subnet_cidr_block" {
  description = "The CIDR block for the Web Subnet."
  default     = "10.0.0.0/26"
}

variable "instance_type" {
  description = "The SKU of EC2 instance type."
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the Amazon Machine Image."
  default     = "ami-04b3c146f744907c7"
}

variable "ssh_key_name" {
  description = "The SSH Key Name in AWS to be used with EC2 instance."
  default     = "DA Default Key"
}