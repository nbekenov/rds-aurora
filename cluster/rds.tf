################################################################################
# PostgreSQL Serverless v2
################################################################################

resource "aws_kms_key" "aurora_kms_key" {
  description             = "CMK for Aurora PostgreSQL server side encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = false
}

resource "aws_kms_alias" "aurora_kms_key_alias" {
  name          = "alias/aurora-data-store-key"
  target_key_id = aws_kms_key.aurora_kms_key.id
}

resource "aws_db_subnet_group" "serverlessv2_sg" {
  name       = "${var.database_name}-subnet_group"
  subnet_ids = data.aws_subnets.private.ids
}

module "aurora_postgresql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.5.0"

  name          = var.database_name
  database_name = var.database_name

  engine_mode    = "serverless"
  engine         = data.aws_rds_engine_version.postgresql.engine
  engine_version = data.aws_rds_engine_version.postgresql.version

  instance_class = "db.serverless"
  serverlessv2_scaling_configuration = {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  master_username                     = var.admin_user_name
  manage_master_user_password         = true
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.aurora_kms_key.arn
  iam_database_authentication_enabled = true
  ca_cert_identifier                  = "rds-ca-rsa2048-g1"

  vpc_id               = data.aws_vpc.vpc.id
  db_subnet_group_name = aws_db_subnet_group.serverlessv2_sg.name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
  }

  monitoring_interval = 60
  apply_immediately   = true
  skip_final_snapshot = true

  deletion_protection = true

}