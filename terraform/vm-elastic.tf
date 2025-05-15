# Elasticsearch
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elastic-vm"
  zone        = var.zone
  platform_id = "standard-v1"
  
  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.es.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

# Kibana
resource "yandex_compute_instance" "kibana" {
  name        = "kibana-vm"
  zone        = var.zone
  platform_id = "standard-v1"
  
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

