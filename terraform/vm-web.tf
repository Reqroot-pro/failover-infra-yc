# Web Servers (2 VM в разных зонах)
resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index + 1}"
  zone        = element(["ru-central1-a", "ru-central1-b"], count.index)
  platform_id = "standard-v1"

  resources {
    cores   = var.vm_cpu
    memory  = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = element([yandex_vpc_subnet.private-a.id, yandex_vpc_subnet.private-b.id], count.index)
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

