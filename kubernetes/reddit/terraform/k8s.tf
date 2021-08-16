resource "yandex_vpc_subnet" "subnet_resource_name" {
  v4_cidr_blocks = ["10.0.0.0/16"]
  name = "kuber-subnetwork"
  zone           = var.zone
  network_id     = yandex_vpc_network.network_resource_name.id
}

resource "yandex_vpc_network" "network_resource_name" {
  name = "kuber-network"
}

resource "yandex_kubernetes_cluster" "zonal_cluster_resource_name" {
  name        = "terraform-test-cluster"
  description = "description"

  network_id = yandex_vpc_network.network_resource_name.id

  master {
    version = "1.19"
    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.subnet_resource_name.id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  labels = {
    my_key       = "otus-devops"
  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

}
######## CLUSTER GROUP

resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.zonal_cluster_resource_name.id
  name        = "test-kuber-group"
  description = "description"
  version     = "1.19"

  labels = {
    "key" = "otus-devops"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.subnet_resource_name.id]
    }

    resources {
      memory = 8
      cores  = 4
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }
    metadata = {
      ssh-keys = format("%s:%s", var.ssh_user, file(var.public_key_path))
    }
    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }


}
