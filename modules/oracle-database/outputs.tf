output "public_fqdn" {
  value = "${element(concat(aws_route53_record.oracle_db_instance_public.*.fqdn,list("")), 0)}"
}

output "internal_fqdn" {
  value = "${element(concat(aws_route53_record.oracle_db_instance_internal.*.fqdn,list("")), 0)}"
}

output "private_ip" {
  value = "${element(concat(aws_instance.oracle_db.*.private_ip,list("")), 0)}"
}

output "ami_id" {
  value = "${element(concat(aws_instance.oracle_db.*.id,list("")), 0)}"
}

output "db_size_parameters" {
  value = {
    database_size  = "${local.database_size}"
    iops           = "${local.iops}"
    disks_quantity = "${local.disks_quantity}"
    size           = "${local.size}"
    total_storage  = "${local.disks_quantity*local.size}"
    iops_ratio     = "${local.iops/local.size} (50 max)"
  }
}

output "db_tf_import" {
  value = {
    instance_id     = "${aws_instance.oracle_db.id}"
    r53_id_internal = "${aws_route53_record.oracle_db_instance_internal.zone_id}-${aws_route53_record.oracle_db_instance_internal.name}_${aws_route53_record.oracle_db_instance_internal.type}"
    r53_id_public   = "${aws_route53_record.oracle_db_instance_public.zone_id}-${aws_route53_record.oracle_db_instance_public.name}_${aws_route53_record.oracle_db_instance_public.type}"
  }
}

output "r53_id_public" {
  value = {
    name = "${aws_route53_record.oracle_db_instance_public.name}"
    fqdn = "${aws_route53_record.oracle_db_instance_public.fqdn}"
  }
}

output "r53_id_internal" {
  value = {
    name = "${aws_route53_record.oracle_db_instance_internal.name}"
    fqdn = "${aws_route53_record.oracle_db_instance_internal.fqdn}"
  }
}
