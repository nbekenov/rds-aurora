# RDS Aurora Cluster creation

[For more details check my post in dev.to](https://dev.to/aws-builders/create-rds-cluster-and-manage-passwords-in-2024-4n3d)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora_postgresql_v2"></a> [aurora\_postgresql\_v2](#module\_aurora\_postgresql\_v2) | terraform-aws-modules/rds-aurora/aws | 8.5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.serverlessv2_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_alias.aurora_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.aurora_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_rds_engine_version.postgresql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_user_name"></a> [admin\_user\_name](#input\_admin\_user\_name) | admin\_user\_name | `string` | `"aurora_admin"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | database\_name | `string` | `"aurorapostgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | postgresql engine\_version | `string` | `"15.4"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | max scaling capacity | `number` | `4` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | min scaling capacity | `number` | `2` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | vpc\_name | `string` | `"main-vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->