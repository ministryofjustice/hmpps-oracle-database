variable "create_volume" {
  description = "create volume"
  default     = false
}

variable "size" {
  description = "volume size"
  default     = 25
}

variable "type" {
  description = "The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2)"
  default     = "io1"
  type        = string
}


variable "iops" {
  description = "The amount of IOPS to provision for the disk. Only valid for type of io1, io2 or gp3."
  default     = 1000
}

variable "throughput" {
  description = "The throughput that the volume supports, in MiB/s. Only valid for type of gp3."
  default     = 125
  type        = number
}

variable "instance_id" {
}

variable "availability_zone" {
}

variable "encrypted" {
  description = "is volume encrypted"
  default     = true
}

variable "kms_key_id" {
}

variable "tags" {
  type = map(string)
}

variable "device_name" {
}

