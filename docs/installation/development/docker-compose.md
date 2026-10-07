# Разработка через Docker Compose

Этот режим предназначен для разработки CMS без обязательного запуска сетевого стенда.

## Предварительные требования

- Docker Engine или Docker Desktop;
- Docker Compose v2;
- Git;
- свободные порты, перечисленные в compose-конфигурации проекта.

## Базовый сценарий

```bash
git clone https://github.com/maintainer64/cms-labs-api.git
cd cms-labs-api
# TODO: указать окончательную команду запуска локального compose-профиля
docker compose up --build
```

После запуска необходимо проверить:

1. health endpoint backend;
2. открытие страницы входа frontend;
3. подключение backend к базе данных;
4. вход демонстрационным пользователем, если включён demo-режим.

## Ограничения

Docker Compose не воспроизводит namespace попытки, Kubernetes RBAC, Clabernetes и маршрутизацию workspace. Для таких изменений используйте [kind](kind.md).

> **Нужна иллюстрация:** скриншот страницы входа локального CMS и подписи к URL frontend/backend.

## Что дописать

- точные профили и переменные окружения;
- команды миграции и seed demo-каталога;
- подключение frontend к локальному backend;
- очистка volumes без случайного удаления пользовательских данных.
