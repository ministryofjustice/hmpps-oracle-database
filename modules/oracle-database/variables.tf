variable "server_name" {
  description = "The name of the server, dns name"
  type        = string
}

variable "ami_id" {
  description = "AWS AMI ID"
  type        = string
}

variable "db_subnet" {
  description = "Subnet for the servers"
  type        = string
}

variable "key_name" {
  description = "Deployer key name"
  type        = string
}

variable "iam_instance_profile" {
  description = "iam instance profile id"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups for the admin server"
  type        = list(string)
}

variable "tags" {
  description = "Tags to match tagging standard"
  type        = map(string)
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
}

variable "bastion_inventory" {
  description = "Bastion environment inventory"
  type        = string
}

variable "project_name" {
  description = "The project name - eg. delius-core"
  type        = string
}

variable "environment_type" {
  description = "The environment type - e.g. dev"
}

variable "region" {
  description = "The AWS region."
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "shortend resource label or name"
}

variable "kms_key_id" {
  description = "ARN of KMS Key"
  type        = string
}

variable "public_zone_id" {
  description = "Public zone id"
  type        = string
}

variable "private_zone_id" {
  description = "Private internal zone id"
  type        = string
}

variable "private_domain" {
  description = "Private internal zone name"
  type        = string
}

variable "vpc_account_id" {
  description = "VPC Account ID"
  type        = string
}

variable "db_size" {
  description = "Database size details"
  type        = map(string)
  ## Example default
  # default     = {
  #   database_size  = "small"
  #   instance_type  = "t3.large"
  #   # disk_iops      = 1000
  #   # disks_quantity = 2          # Do not decrease this
  #   # disk_size      = 500        # Do not decrease this
  #
  #   disks_quantity      = 2   # Do not decrease this
  #   disks_quantity_data = 1
  #   disk_iops_data      = 1000
  #   disk_iops_flash     = 500
  #   disk_iops_root      = 1000
  #   disk_size_data      = 500 # Do not decrease this
  #   disk_size_flash     = 500 # Do not decrease this
  #   # total_storage  = 1000 # This should equal disks_quantity x disk_size
  # }
}

variable "ansible_vars" {
  description = "Ansible vars for user_data script"
  type        = map(string)
}

