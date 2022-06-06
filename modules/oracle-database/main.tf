data "template_file" "user_data" {
  template = file("${path.module}/user_data/user_data.sh")

  vars = {
    project_name         = var.project_name
    env_identifier       = var.environment_identifier
    short_env_identifier = var.short_environment_identifier
    region               = var.region
    server_name          = var.server_name
    app_name             = element(split("-", var.server_name), 0) # delius-db-1 -> delius - misboe-db-2 -> misboe
    route53_sub_domain   = var.environment_name
    private_domain       = var.private_domain
    account_id           = var.vpc_account_id
    bastion_inventory    = var.bastion_inventory
    application          = var.tags["application"]

    service_user_name             = var.ansible_vars["service_user_name"]
    database_global_database_name = var.ansible_vars["database_global_database_name"]
    database_sid                  = var.ansible_vars["database_sid"]
    database_characterset         = var.ansible_vars["database_characterset"]
    oracle_dbca_template_file     = var.ansible_vars["oracle_dbca_template_file"]
    database_type                 = lookup(var.ansible_vars, "database_type", "NOTSET")
    s3_oracledb_backups_arn       = lookup(var.ansible_vars, "s3_oracledb_backups_arn", "NOTSET")
    dependencies_bucket_arn       = lookup(var.ansible_vars, "dependencies_bucket_arn", "NOTSET")
    database_bootstrap_restore    = lookup(var.ansible_vars, "database_bootstrap_restore", "False")
    database_backup               = lookup(var.ansible_vars, "database_backup", "NOTSET")
    database_backup_sys_passwd    = lookup(var.ansible_vars, "database_backup_sys_passwd", "NOTSET")
    database_backup_location      = lookup(var.ansible_vars, "database_backup_location", "NOTSET")
    asm_disks_quantity            = var.db_size["disks_quantity"]
    asm_disks_quantity_data       = var.db_size["disks_quantity_data"]
  }
}

locals {
  database_size          = var.db_size["database_size"]
  instance_type          = var.db_size["instance_type"]
  # disk_type_root       = var.db_size["disk_type_root"]
  # disk_throughput_root = var.db_size["disk_throughput_root"]
  disk_type_data       = var.db_size["disk_type_data"]
  disk_throughput_data = var.db_size["disk_throughput_data"]
  disks_quantity         = var.db_size["disks_quantity"]
  disks_quantity_data    = var.db_size["disks_quantity_data"]
  disk_iops_data         = var.db_size["disk_iops_data"]
  disk_iops_flash        = var.db_size["disk_iops_flash"]
  disk_iops_root         = var.db_size["disk_iops_root"]
  disk_size_data         = var.db_size["disk_size_data"]
  disk_size_flash        = var.db_size["disk_size_flash"]
  tags_name_prefix       = "${var.environment_name}-${var.server_name}"
}

resource "aws_instance" "oracle_db" {
  ami                    = var.ami_id
  instance_type          = local.instance_type
  subnet_id              = var.db_subnet
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  source_dest_check      = false
  vpc_security_group_ids = var.security_group_ids
  user_data              = data.template_file.user_data.rendered

  root_block_device {
    delete_on_termination = true
    volume_size           = 256
    volume_type           = "io1"
    iops                  = local.disk_iops_root
  }

  tags = merge({
    Name          = "${var.environment_name}-${var.server_name}"
    InventoryHost = "${var.environment_name}-${var.server_name}"
    Database      = var.server_name
  }, var.tags)

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

resource "aws_route53_record" "oracle_db_instance_internal" {
  zone_id = var.private_zone_id
  name    = var.server_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.oracle_db.private_ip]
}

resource "aws_route53_record" "oracle_db_instance_public" {
  zone_id = var.public_zone_id
  name    = var.server_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.oracle_db.private_ip]
}

