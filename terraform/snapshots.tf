#Разовый снапшот
resource "yandex_compute_snapshot" "manual_snapshot_bastion" {
  name        = "manual-snapshot-bastion"
  description = "Manual snapshot of bastion disk"
  source_disk_id = yandex_compute_instance.bastion.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "manual_snapshot_web_0" {
  name        = "manual-snapshot-web-0"
  description = "Manual snapshot of web-0 disk"
  source_disk_id = yandex_compute_instance.web[0].boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "manual_snapshot_web_1" {
  name        = "manual-snapshot-web-1"
  description = "Manual snapshot of web-1 disk"
  source_disk_id = yandex_compute_instance.web[1].boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "manual_snapshot_zabbix" {
  name        = "manual-snapshot-zabbix"
  description = "Manual snapshot of zabbix disk"
  source_disk_id = yandex_compute_instance.zabbix.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "manual_snapshot_elasticsearch" {
  name        = "manual-snapshot-elasticsearch"
  description = "Manual snapshot of elasticsearch disk"
  source_disk_id = yandex_compute_instance.elasticsearch.boot_disk[0].disk_id
}

resource "yandex_compute_snapshot" "manual_snapshot_kibana" {
  name        = "manual-snapshot-kibana"
  description = "Manual snapshot of kibana disk"
  source_disk_id = yandex_compute_instance.kibana.boot_disk[0].disk_id
}

#Ежедневное расписание
resource "yandex_compute_snapshot_schedule" "daily" {
  name = "daily-snapshot-schedule"

  schedule_policy {
    expression = "0 0 * * *"
  }

  snapshot_count = 7

  snapshot_spec {
    description = "Daily auto snapshot"
    labels = {
      environment = "prod"
    }
  }

  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.web[0].boot_disk[0].disk_id,
    yandex_compute_instance.web[1].boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id,
  ]
}
