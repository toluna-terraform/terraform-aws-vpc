variable "amazon_ec2_linux_image" {
  description = "Amazon linux image for NAT instance."
  type        = string
  default     = "amzn2-ami-kernel-5.10-hvm-*"
}

variable "amazon_ec2_instance_virtualization_type" {
  description = "Amazon linux image for NAT instance."
  type        = string
  default     = "hvm"
}

variable "amazon_owner_id" { 
  description = "Amazong owner id."
  type        = string
  default     = "137112412989"
}

variable "ssm_agent_policy" {
  description = "Policy of SSM agent."
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "name_suffix" {
    type = string
    description = ""
}

variable "aws_vpc_id" {
  type = string
}

variable "nat_instance_type" {
  type = string
}

variable "number_of_azs" {
  type = number
}

variable "private_subnets_ids" {}

variable "public_subnets_ids" {}
