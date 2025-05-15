resource "yandex_vpc_network" "main" {
  name = "main-network"
}

# Публичные подсети
resource "yandex_vpc_subnet" "public-a" {
  name           = "public-subnet-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
}

resource "yandex_vpc_subnet" "public-b" {
  name           = "public-subnet-b"
  v4_cidr_blocks = ["10.0.3.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
}

# Приватные подсети
resource "yandex_vpc_subnet" "private-a" {
  name           = "private-subnet-a"
  v4_cidr_blocks = ["10.0.2.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  route_table_id = yandex_vpc_route_table.nat_route.id
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-subnet-b"
  v4_cidr_blocks = ["10.0.4.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  route_table_id = yandex_vpc_route_table.nat_route.id
}

# NAT Gateway
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Таблица маршрутизации с NAT
resource "yandex_vpc_route_table" "nat_route" {
  depends_on = [yandex_vpc_gateway.nat_gateway]
  name       = "nat-route-table"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id        = yandex_vpc_gateway.nat_gateway.id
  }
}
