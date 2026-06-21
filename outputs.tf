output "vm_info" {
  description = "VM`s info"
  value = <<EOT

=========================================
  WEB:
=========================================
  Name:          ${yandex_compute_instance.platform.name}
  FQDN:          ${yandex_compute_instance.platform.fqdn}
  External IP:   ${yandex_compute_instance.platform.network_interface.0.nat_ip_address}
  Internal IP:   ${yandex_compute_instance.platform.network_interface.0.ip_address}
  CPU Cores:     ${yandex_compute_instance.platform.resources.0.cores}
  Core Fraction: ${yandex_compute_instance.platform.resources.0.core_fraction}%
  RAM GB:        ${yandex_compute_instance.platform.resources.0.memory}
  Disk Size GB:  ${yandex_compute_instance.platform.boot_disk.0.initialize_params.0.size}

=========================================
  DB:
=========================================
  Name:          ${yandex_compute_instance.platform-db.name}
  FQDN:          ${yandex_compute_instance.platform-db.fqdn}
  External IP:   ${yandex_compute_instance.platform-db.network_interface.0.nat_ip_address}
  Internal IP:   ${yandex_compute_instance.platform-db.network_interface.0.ip_address}
  CPU Cores:     ${yandex_compute_instance.platform-db.resources.0.cores}
  Core Fraction: ${yandex_compute_instance.platform-db.resources.0.core_fraction}%
  RAM GB:        ${yandex_compute_instance.platform-db.resources.0.memory}
  Disk Size GB:  ${yandex_compute_instance.platform-db.boot_disk.0.initialize_params.0.size}
EOT
}
