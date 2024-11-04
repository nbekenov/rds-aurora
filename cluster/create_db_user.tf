resource "aws_ssm_document" "rds_bootstrap_document" {
  name            = "rds_user_bootstrap"
  document_type   = "Command"
  document_format = "YAML"
  content = templatefile("${path.module}/templates/rds_bootstrap_create_user.yml", {
    dbhost = module.aurora_postgresql_v2.cluster_endpoint
    dbport = module.aurora_postgresql_v2.cluster_port
    dbname = module.aurora_postgresql_v2.cluster_database_name
    pguser = var.postgres_user
  })
}
 
data "aws_secretsmanager_secret_version" "rds_db_user_secret" {
  secret_id = module.aurora_postgresql_v2.cluster_master_user_secret[0].secret_arn
}
 
resource "null_resource" "run_rds_user_bootstrap" {
  provisioner "local-exec" {
    command = join(" ", [
      "aws ssm send-command --document-name ${aws_ssm_document.rds_bootstrap_document.name}",
      "--targets Key=tag:Name,Values=ssm-bastion-host",
      "--timeout-seconds 600",
      "--max-concurrency '1'",
      "--max-errors '0'",
      "--region ${var.aws_region}",
      "--output text",
      "--parameters '${join(",", [
        "{\"dbuser\":[\"${jsondecode(data.aws_secretsmanager_secret_version.rds_db_user_secret.secret_string).username}\"]",
        "\"dbpassword\":[\"${jsondecode(data.aws_secretsmanager_secret_version.rds_db_user_secret.secret_string).password}\"]}"
      ])}'"
    ])
  }
 
  depends_on = [aws_ssm_document.rds_bootstrap_document]
 
  triggers = {
    always_run = timestamp()  # Re-runs every time apply is called
  }
}