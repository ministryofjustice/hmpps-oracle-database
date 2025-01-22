output "public_fqdn" {
  value = length(aws_route53_record.oracle_db_instance_public) > 0 ? aws_route53_record.oracle_db_instance_public[0].fqdn : null
}

output "internal_fqdn" {
  value = length(aws_route53_record.oracle_db_instance_internal) > 0 ? aws_route53_record.oracle_db_instance_internal[0].fqdn : null
}

output "private_ip" {
  value = aws_instance.oracle_db.private_ip
}

output "ami_id" {
  value = aws_instance.oracle_db.id
}

output "db_size_parameters" {
  value = {
    database_size       = local.database_size
    disks_quantity      = local.disks_quantity
    disks_quantity_data = local.disks_quantity_data
    disk_iops_data      = local.disk_iops_data
    disk_iops_flash     = local.disk_iops_flash
    disk_iops_root      = local.disk_iops_root
    disk_size_data      = local.disk_size_data
    disk_size_flash     = local.disk_size_flash
    total_storage       = local.disks_quantity * local.disk_size_data
    iops_ratio_data     = "${local.disk_iops_data / local.disk_size_data} (50 max)"
    iops_ratio_flash    = "${local.disk_iops_flash / local.disk_size_flash} (50 max)"
  }
}

output "db_tf_import" {
  value = {
    instance_id     = aws_instance.oracle_db.id
    r53_id_internal = "${aws_route53_record.oracle_db_instance_internal.zone_id}-${aws_route53_record.oracle_db_instance_internal.name}_${aws_route53_record.oracle_db_instance_internal.type}"
    r53_id_public   = "${aws_route53_record.oracle_db_instance_public.zone_id}-${aws_route53_record.oracle_db_instance_public.name}_${aws_route53_record.oracle_db_instance_public.type}"

    r53_id_internal = length(aws_route53_record.oracle_db_instance_internal) > 0 ? "${aws_route53_record.oracle_db_instance_internal[0].zone_id}-${aws_route53_record.oracle_db_instance_internal[0].name}_${aws_route53_record.oracle_db_instance_internal[0].type}" : null
    r53_id_public   = length(aws_route53_record.oracle_db_instance_public) > 0 ? "${aws_route53_record.oracle_db_instance_publi[0].zone_id}-${aws_route53_record.oracle_db_instance_publi[0].name}_${aws_route53_record.oracle_db_instance_public[0].type}" : null
  }
}

output "r53_id_public" {
  value = {
    name = length(aws_route53_record.oracle_db_instance_public) > 0 ? aws_route53_record.oracle_db_instance_public[0].name : null
    fqdn = length(aws_route53_record.oracle_db_instance_public) > 0 ? aws_route53_record.oracle_db_instance_public[0].fqdn : null
  }
}

output "r53_id_internal" {
  value = {
    name = length(aws_route53_record.oracle_db_instance_internal) > 0 ? aws_route53_record.oracle_db_instance_internal[0].name : null
    fqdn = length(aws_route53_record.oracle_db_instance_internal) > 0 ? aws_route53_record.oracle_db_instance_internal[0].fqdn : null
  }
}

output "cpu_core_count" {
  value = aws_instance.oracle_db.cpu_core_count
}