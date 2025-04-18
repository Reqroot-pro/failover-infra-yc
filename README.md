# Курсовой проект: отказоустойчивая инфраструктура для сайта в Yandex Cloud

# Failover Infrastructure in Yandex Cloud

Проект по построению отказоустойчивой инфраструктуры в Yandex Cloud с использованием Terraform и Ansible.

## Состав

- Web-серверы (nginx)
- Application Load Balancer
- Мониторинг (Zabbix)
- Логирование (ELK: Elasticsearch + Kibana + Filebeat)
- Bastion host
- Резервное копирование (Snapshots)

## Как использовать

1. Склонируй репозиторий:
   ```bash
   git clone https://github.com/Reqroot-pro/failover-infra-yc.git
   cd failover-infra-yc

