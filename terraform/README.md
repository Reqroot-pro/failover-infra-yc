## 1. Подготовка перед запуском Terraform

Перед запуском необходимо убедиться, что **сервисный ключ Yandex Cloud** подключен.

[Инструкция по подключению сервисного аккаунта](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart )

---

## 2. Устранение ошибки: `Invalid provider registry host`

Если при иницилизации проекта вы получаете ошибку:
Error: Invalid provider registry host


Следуйте [официальной инструкции от Yandex Cloud](https://yandex.cloud/ru/docs/troubleshooting/terraform/known-issues/invalid-provider-registry-host ).

### ✅ Решение:

Если файла `.terraformrc` ещё нет — создайте его в домашней директории (`~/.terraformrc`) со следующим содержимым:

```hcl
provider_installation {
  network_mirror {
    url    = "https://terraform-mirror.yandexcloud.net/ "
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
