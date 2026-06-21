### NETWORK

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop-db"
  description = "VPC network & subnet name"
}

### VM PARAMS

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM DB name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID"
}



/* ---------------------------------------

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Number of CPU"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "RAM size in gb"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Core fraction %"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Preemptible"
}
variable "vm_db_nat" {
  type        = bool
  default     = false #true
  description = "Enables NAT"
}

variable "vm_db_serial_port" {
  type        = number
  default     = 1
  description = "Enable or disable serial port"
}

--------------------------------------- */


### TASK 4
variable "vm_db_hostname" {
  type        = string
  default     = "develop-db"
  description = "FQDN DB"
}

### TASK 5
variable "vm_db_env" {
  type    = string
  default = "netology"
}

variable "vm_db_role" {
  type    = string
  default = "develop-db"
}

variable "vm_db_user" {
  type    = string
  default = "gilels"
}


