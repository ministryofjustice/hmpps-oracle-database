
variable "create_volume" {
  description = "create volume"
  default = false
}

variable "size" {
  description = "volume size"
  default = 25
}

variable "iops" {
  description = "volume iops"
  default = 1000
}

variable "instance_id" {
  type = "list"
}

variable "availability_zone" {
  type = "list"
}

variable "encrypted" {
  description = "is volume encrypted"
  default = true
}

variable "kms_key_id" {}

variable "tags" {
  type = "map"
}

variable "device_name" {}
