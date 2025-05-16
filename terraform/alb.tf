# Создание балансировщика нагрузки
resource "yandex_alb_load_balancer" "web_lb" {
  name        = "web-lb"
  folder_id   = var.folder_id
  description = "Web Load Balancer"
  network_id  = yandex_vpc_network.main.id

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.public-a.id
    }
  }

  listener {
    name = "listener-http"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}

# Создание целевой группы
resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group"

  target {
    subnet_id   = yandex_vpc_subnet.private-a.id
    ip_address  = yandex_compute_instance.web[0].network_interface[0].ip_address
  }

  target {
    subnet_id   = yandex_vpc_subnet.private-b.id
    ip_address  = yandex_compute_instance.web[1].network_interface[0].ip_address
  }
}

# Создание бэкенд группы
resource "yandex_alb_backend_group" "web_backend_group" {
  name = "web-backend-group"

  http_backend {
    name                   = "backend-1"
    weight                 = 1
    target_group_ids       = [yandex_alb_target_group.web_target_group.id]
    port                   = 80
    load_balancing_config {
      panic_threshold       = 90
    }
    healthcheck {
      timeout               = "5s"
      interval              = "2s"
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      http_healthcheck {
        path                = "/"
      }
    }
  }
}

# Создание HTTP-роутера
resource "yandex_alb_http_router" "web_router" {
  name = "web-router"
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "web_virtual_host" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web_router.id

  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend_group.id
      }
    }
  }
}
