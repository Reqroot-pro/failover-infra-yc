# Bastion Host
resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
  zone        = var.zone
  platform_id = "standard-v1"
  
  resources {
    cores  = var.vm_cpu
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
