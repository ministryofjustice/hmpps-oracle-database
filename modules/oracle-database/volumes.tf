## To use the latest generation of EC2 Instances HVM Nitro based, the device name as listed in lsblk
## is /dev/nvme[0-26]n1 - however this is not a valid EBS device name; resulting in the following error code: "InvalidParameterValue".
## As per documentation https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
## We'll use /dev/xvd[c][a-z] as availible.

## Instance Type Limits
## A1, C5, C5d, C5n, M5, M5a, M5d, p3dn.24xlarge, R5, R5a, R5d, T3, and z1d instances support
## a maximum of 28 attachments, including network interfaces, EBS volumes, and NVMe instance
## store volumes. Every instance has at least one network interface attachment. NVMe instance
## store volumes are automatically attached. For example, if you have no additional network
## interface attachments on an EBS-only instance, you can attach up to 27 EBS volumes to it.
## If you have one additional network interface on an instance with 2 NVMe instance store
## volumes, you can attach 24 EBS volumes to it.

# For this reason we shall enable up to 24 as the base AMI will have 2 already attached.

# db_size_delius_core = {
#   database_size        = "x_large"
#   instance_type        = "r5.4xlarge"
#   disk_type_data       = "io1" # Requires iops and throughput to be set
#   disk_throughput_data = 750 # Only relevant when disks_volume_type = "gp3"
#   disk_type_root       = "io1" # Requires iops and throughput to be set
#   disk_throughput_root = 125 # Only relevant when disks_volume_type = "gp3"
#   disks_quantity       = 16 # Do not decrease this
#   disks_quantity_data  = 10
#   disk_iops_root       = 1000
#   disk_iops_data       = 1000
#   disk_iops_flash      = 500
#   disk_size_data       = 1000 # Do not decrease this
#   disk_size_flash      = 1000 # Do not decrease this
#   ## total_storage     = 16000 # This should equal disks_quantity x disk_size
# }

module "dev_xvdca" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 1 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 1 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 1 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdca"
    },
  )
  device_name = "/dev/xvdca"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcb" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 2 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 2 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 2 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcb"
    },
  )
  device_name = "/dev/xvdcb"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcc" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 3 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 3 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 3 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcc"
    },
  )
  device_name = "/dev/xvdcc"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcd" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 4 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 4 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 4 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcd"
    },
  )
  device_name = "/dev/xvdcd"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdce" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 5 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 5 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 5 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdce"
    },
  )
  device_name = "/dev/xvdce"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcf" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 6 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 6 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 6 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcf"
    },
  )
  device_name = "/dev/xvdcf"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcg" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 7 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 7 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 7 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcg"
    },
  )
  device_name = "/dev/xvdcg"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdch" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 8 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 8 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 8 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdch"
    },
  )
  device_name = "/dev/xvdch"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdci" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 9 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 9 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 9 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdci"
    },
  )
  device_name = "/dev/xvdci"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcj" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 10 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 10 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 10 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcj"
    },
  )
  device_name = "/dev/xvdcj"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdck" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 11 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 11 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 11 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdck"
    },
  )
  device_name = "/dev/xvdck"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcl" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 12 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 12 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 12 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcl"
    },
  )
  device_name = "/dev/xvdcl"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcm" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 13 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 13 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 13 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcm"
    },
  )
  device_name = "/dev/xvdcm"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcn" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 14 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 14 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 14 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcn"
    },
  )
  device_name = "/dev/xvdcn"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdco" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 15 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 15 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 15 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdco"
    },
  )
  device_name = "/dev/xvdco"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcp" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 16 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 16 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 16 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcp"
    },
  )
  device_name = "/dev/xvdcp"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcq" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 17 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 17 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 17 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcq"
    },
  )
  device_name = "/dev/xvdcq"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcr" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 18 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 18 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 18 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcr"
    },
  )
  device_name = "/dev/xvdcr"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcs" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 19 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 19 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 19 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcs"
    },
  )
  device_name = "/dev/xvdcs"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdct" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 20 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 20 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 20 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdct"
    },
  )
  device_name = "/dev/xvdct"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcu" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 21 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 21 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 21 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcu"
    },
  )
  device_name = "/dev/xvdcu"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcv" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 22 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 22 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 22 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcv"
    },
  )
  device_name = "/dev/xvdcv"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcw" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 23 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 23 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 23 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcw"
    },
  )
  device_name = "/dev/xvdcw"
  instance_id = aws_instance.oracle_db.id
}

module "dev_xvdcx" {
  source            = "./modules/ebs-volume"
  create_volume     = local.disks_quantity >= 24 ? true : false
  availability_zone = aws_instance.oracle_db.availability_zone
  type              = local.disk_type_data
  throughput        = local.disk_throughput_data # only relevant for gp3
  iops              = local.disks_quantity_data >= 24 ? local.disk_iops_data : local.disk_iops_flash
  size              = local.disks_quantity_data >= 24 ? local.disk_size_data : local.disk_size_flash
  kms_key_id        = var.kms_key_id
  tags = merge(
    var.tags,
    {
      "Name" = "${local.tags_name_prefix}-xvdcx"
    },
  )
  device_name = "/dev/xvdcx"
  instance_id = aws_instance.oracle_db.id
}

