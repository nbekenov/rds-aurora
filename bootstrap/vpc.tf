locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.vpc_name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  enable_nat_gateway             = true
  single_nat_gateway             = true
  enable_vpn_gateway             = false
  enable_dns_hostnames           = true
  enable_dns_support             = true
  manage_default_security_group  = true
  default_security_group_name    = "${var.vpc_name}-default-sg-do-not-use"
  default_security_group_ingress = []
  default_security_group_egress  = []
}

# ----------------
# VPC Endpoints
# ----------------
locals {
  endpoints = {
    "endpoint-ssm" = {
      name        = "ssm"
      private_dns = false
    },
    "endpoint-ssm-messages" = {
      name        = "ssmmessages"
      private_dns = false
    },
    "endpoint-ec2-messages" = {
      name        = "ec2messages"
      private_dns = false
    },
  }
}

resource "aws_vpc_endpoint" "endpoints" {
  vpc_id              = module.vpc.vpc_id
  for_each            = local.endpoints
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value.name}"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = data.aws_subnets.private.ids
  private_dns_enabled = each.value.private_dns

}

# SG for VPC endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  name_prefix = "vpc-endpoint-sg"
  vpc_id      = module.vpc.vpc_id
  description = "security group for VPC endpoints"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "allow all TCP within VPC CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic from VPC"
  }

  tags = {
    Name = "vpc-endpoints-sg"
  }
}