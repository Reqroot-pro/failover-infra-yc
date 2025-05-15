# Bastion
resource "yandex_vpc_security_group" "bastion" {
  name       = "sg-bastion"
  network_id = yandex_vpc_network.main.id
  
  ingress {
    description    = "Allow SSH from anywhere"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
   egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web servers
resource "yandex_vpc_security_group" "web" {
  name       = "sg-web"
  network_id = yandex_vpc_network.main.id
  
  ingress {
    description       = "Allow SSH from Bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }  
  
  ingress {
    description    = "Allow HTTP from Load Balancer"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description       = "Allow Zabbix agent passive check"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix_server.id
  }
  
   egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Zabbix server
resource "yandex_vpc_security_group" "zabbix_server" {
  name       = "sg-zabbix-server"
  network_id = yandex_vpc_network.main.id
  
  ingress {
    description       = "Allow SSH from Bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }
  
  ingress {
    description    = "Allow HTTP from anywhere"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description    = "Allow Zabbix agent active check"
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elasticsearch
resource "yandex_vpc_security_group" "es" {
  name       = "sg-es"
  network_id = yandex_vpc_network.main.id

  ingress {
    description       = "Allow SSH from Bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    description       = "Allow Elasticsearch REST API from Web"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.web.id
  }
  
  ingress {
    description       = "Allow Kibana access"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.kibana.id
  }
  
  egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Kibana
resource "yandex_vpc_security_group" "kibana" {
  name       = "sg-kibana"
  network_id = yandex_vpc_network.main.id
  
  ingress {
    description       = "Allow SSH from Bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }
  
  ingress {
    description    = "Allow HTTP to Kibana"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
