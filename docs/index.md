---
page_title: "hostkey Provider"
description: |-
  Terraform-провайдер Hostkey InvAPI (серверы, SSH-ключи, IP, DNS) для портала .ru.
---

# Провайдер Hostkey (RU)

Управление инфраструктурой Hostkey через [InvAPI](https://hostkey.ru/documentation/apidocs/api_index/) (`invapi.hostkey.ru`).  
Ключи аккаунта: InvAPI → **Имя пользователя → API ключи** ([документация](https://hostkey.ru/documentation/account/api_key_account/)).

Портал `.com`: провайдер [`hostkey-cloud/hostkey-com`](https://registry.terraform.io/providers/hostkey-cloud/hostkey-com/latest).

Быстрый старт: [GitHub README](https://github.com/hostkey-cloud/terraform-provider-hostkey-ru/blob/main/README.md).

## Миграция с `hostkey-cloud/hostkey`

1. Смените `source` на `hostkey-cloud/hostkey-ru`, версия `~> 0.2`.
2. Удалите атрибут `region`.
3. `terraform state replace-provider 'registry.terraform.io/hostkey-cloud/hostkey' 'registry.terraform.io/hostkey-cloud/hostkey-ru'`

## Пример

```hcl
terraform {
  required_providers {
    hostkey = {
      source  = "hostkey-cloud/hostkey-ru"
      version = "~> 0.2"
    }
  }
}

provider "hostkey" {
  # api_key из HOSTKEY_API_KEY / HOSTKEY_API_TOKEN, или явно
}
```

## Schema

### Optional

- `api_key` (String, Sensitive) API-ключ аккаунта InvAPI. Env: `HOSTKEY_API_KEY` или `HOSTKEY_API_TOKEN`.
- `base_url` (String) Переопределение InvAPI URL. По умолчанию `https://invapi.hostkey.ru/`. HTTP только для `localhost`. Хосты `.com` отклоняются. Env: `HOSTKEY_BASE_URL` или `HOSTKEY_API_URL`.
- `token_ttl` (Number) TTL сессии `auth/login` в секундах (по умолчанию `3600`).
- `http_timeout` (Number) Таймаут HTTP в секундах (по умолчанию `60`).
- `max_retries` (Number) Повторы retryable ошибок InvAPI (по умолчанию `3`).

## Troubleshooting

| Ошибка / симптом | Что делать |
|-----------------|------------|
| `InvAPI account has no servers` / `NO_APPROPRIATE_SERVERS` | InvAPI не выдаёт сессию на **пустом** аккаунте (0 серверов) — это не «неверный ключ». Закажите первый сервер в панели, затем повторите Terraform. Ключ должен быть аккаунтным (`Any`). |
| Другие сбои `auth/login` | Аккаунтный ключ (`Any`); этот провайдер только `invapi.hostkey.ru` |
| `InvAPI host … belongs to the other Hostkey portal` | Нужен [`hostkey-cloud/hostkey-com`](https://registry.terraform.io/providers/hostkey-cloud/hostkey-com/latest) |
| `Catalog verification failed` | `terraform plan` с настроенным провайдером; проверьте id через data sources |
| Неоднозначный `traffic_plan_name` | [hostkey_traffic_plans](data-sources/traffic_plans.md) и `instance_id`; подсказки `(10000 P)` / `- FREE` или `traffic_plan_id` |
| id `pending:<invoice>` | Deploy после Paid-заказа ещё идёт. `plan` — in-place; `apply` ждёт **этот invoice**. Статус — в панели Hostkey |
| `Failed to query available provider packages` | Зеркало Yandex Cloud в `~/.terraformrc` / `%APPDATA%\terraform.rc`. `source` = `hostkey-cloud/hostkey-ru`. См. [README](https://github.com/hostkey-cloud/terraform-provider-hostkey-ru/blob/main/README.md). |
