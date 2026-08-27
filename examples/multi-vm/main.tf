terraform {
  required_providers {
    hostkey = {
      source  = "hostkey-cloud-ru/hostkey-ru"
      version = "~> 0.2"
    }
  }
  required_version = ">= 1.0"
}

provider "hostkey" {
  http_timeout = 300
}

variable "root_pass" {
  type      = string
  sensitive = true
}

# Three VMs in one apply (default parallelism — concurrent Creates).
# Unique hostnames help pending correlation across invoices.

resource "hostkey_server" "pico_nl" {
  preset_name       = "vm.pico"
  location_name     = "NL"
  os_name           = "Ubuntu 22.04"
  traffic_plan_name = "3 TB / 1 Gbps VM"
  deploy_period     = "monthly"
  root_pass         = var.root_pass
  hostname          = "tf-par-pico-nl"
  reinstall_trigger = "os-hn-check-20260827"
  power_state       = "on"
  cancellation_type = 1
  timeouts {
    create = "90m"
    update = "90m"
    delete = "30m"
  }
}

resource "hostkey_server" "v2pico_fi" {
  preset_name       = "vm.v2-pico"
  location_name     = "FI"
  os_name           = "Ubuntu 22.04"
  traffic_plan_name = "3 TB / 1 Gbps VM"
  deploy_period     = "monthly"
  root_pass         = var.root_pass
  hostname          = "tf-par-v2pico-fi"
  power_state       = "on"
  cancellation_type = 1
  timeouts {
    create = "90m"
    update = "90m"
    delete = "30m"
  }
}

resource "hostkey_server" "pico_ru" {
  preset_name       = "vm.pico"
  location_name     = "RU"
  os_name           = "Ubuntu 22.04"
  traffic_plan_name = "3Tb @1Gbps VPS RU"
  deploy_period     = "monthly"
  root_pass         = var.root_pass
  hostname          = "tf-par-pico-ru"
  power_state       = "on"
  cancellation_type = 1
  timeouts {
    create = "90m"
    update = "90m"
    delete = "30m"
  }
}

output "pico_nl" {
  value = { id = hostkey_server.pico_nl.id, ip = hostkey_server.pico_nl.main_ipv4, inv = hostkey_server.pico_nl.invoice }
}
output "v2pico_fi" {
  value = { id = hostkey_server.v2pico_fi.id, ip = hostkey_server.v2pico_fi.main_ipv4, inv = hostkey_server.v2pico_fi.invoice }
}
output "pico_ru" {
  value = { id = hostkey_server.pico_ru.id, ip = hostkey_server.pico_ru.main_ipv4, inv = hostkey_server.pico_ru.invoice }
}