# Second VM (FI) — unpaid-invoice Warning check. Paid apply may still run in examples/basic (NL).

terraform {
  required_providers {
    hostkey = {
      source  = "hostkey-cloud-ru/hostkey-ru"
      version = "~> 0.2"
    }
  }
  required_version = ">= 1.0"
}

provider "hostkey" {}

variable "root_pass" {
  type      = string
  sensitive = true
}

resource "hostkey_server" "web" {
  preset_name       = "vm.pico"
  location_name     = "FI"
  os_name           = "Ubuntu 22.04"
  traffic_plan_name = "3 TB / 1 Gbps VM"
  deploy_period     = "monthly"
  root_pass         = var.root_pass
  power_state       = "on"
  cancellation_type = 1
  hostname          = "tf-unpaid-fi-check"

  timeouts {
    create = "90m"
    delete = "30m"
  }
}

output "server_id" {
  value = hostkey_server.web.id
}

output "main_ipv4" {
  value = hostkey_server.web.main_ipv4
}

output "invoice" {
  value = hostkey_server.web.invoice
}
