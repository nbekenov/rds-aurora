data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_availability_zones" "available" {}


data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-*"]
  }
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}