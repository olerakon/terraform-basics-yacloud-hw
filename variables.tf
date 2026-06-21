###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

/* ---------------
variable "vms_ssh_public_root_key" {
  type        = string
  description = "Public SSH key for VM access"
}
---------------- */


###TASK 2

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Family image"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "VM Web name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID"
}


/* ---------------------------------------
variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "RAM size in gb"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Core fraction %"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = false #true
  description = "Enables NAT"
}

variable "vm_web_serial_port" {
  type        = number
  default     = 1
  description = "Enable or disable serial port"
}
------------------------------------------------ */

### TASK 4

variable "vm_web_hostname" {
  type        = string
  default     = "develop-web"
  description = "FQDN WEB"
}

### TASK 5
variable "vm_web_env" {
  type    = string
  default = "netology"
}

variable "vm_web_role" {
  type    = string
  default = "develop-web"
}

variable "vm_web_user" {
  type    = string
  default = "gilels"
}

### TASK 6

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    nat           = bool
    preemptible   = bool
  }))
  description = "resources"
}

variable "metadata" {
  type        = map(string)
  description = "metadata"
}
