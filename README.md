# Terraform AWS Public Subnet Module

This is Terraform module to create public subnet with network acl, route table, internet gateways, nat gateways in AWS.

**This module requires Terraform v0.11.**

```hcl
module "public_subnet" {
  source = "github.com/SanchitBansal/terraform-public-subnet.git"

  vpc_id = "vpc-xxxxx"
  name = "lb"
  environment = "test"
  availability_zones  = ["ap-south-1a", "ap-south-1b"]

  custom_tags = {
    "organization" = "github"
    "businessunit" = "techteam"
  }

  public_subnets = ["192.168.100.0/25", "192.168.100.128/25"]

  public_network_acl_egress = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
    {
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
  ]

  public_network_acl_ingress = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
    {
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
  ]
}
```

The module creates subnet CIDRs provided in public_subnets var and names them in the combination of "environment", "name" and "availability zone". Along with it, it creates internet gateway to make the subnet public and also nat gateways which will be used while allowing private subnets to talk to internet.

Also you can increase/ decrease availability zones as the requirement comes in future, it won't break :)

```hcl
module "public_subnet" {
  source = "github.com/SanchitBansal/terraform-public-subnet.git"

  vpc_id = "vpc-xxxxx"
  name = "lb"
  environment = "test"
  availability_zones  = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

  custom_tags = {
    "organization" = "github"
    "businessunit" = "techteam"
  }

  public_subnets = ["192.168.100.0/25", "192.168.100.128/25", "192.168.101.0/25"]

  public_network_acl_egress = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
    },
    {
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
  ]

  public_network_acl_ingress = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
      protocol   = "tcp"
    },
    {
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
      protocol   = "tcp"
    },
  ]
}
```

**I will keep enhancing it if found any issues or any feature request from your side**
