# Zabbix Server VM
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix-server"
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
    security_group_ids = [yandex_vpc_security_group.zabbix_server.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

