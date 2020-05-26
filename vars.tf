/**
 * variables that will be used while creating infra
 */
variable "profile" {
  description = "profile name to get valid credentials of account"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ap-south-1"
}

variable "name" {
  description = "the name of your subnet"
}

variable "environment" {
  description = "the name of your environment"
}

variable "custom_tags" {
  type        = "map"
  default     = {}
  description = "map of tags to be added"
}

variable "public_subnets" {
  description = "List of all public subnet CIDRs"
  type        = "list"
}

variable "vpc_id" {
  description = "vpc id in which subnet to create"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = "list"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}
