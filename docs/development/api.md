# Разработка cms-labs-api из исходников

Монорепозиторий [`cms-labs-api`](https://github.com/cms-lab-core/cms-labs-api) содержит backend, frontend, Clabgate и локальную Kubernetes-интеграцию. Его README и [`k8s/local-kind/README.md`](https://github.com/cms-lab-core/cms-labs-api/blob/main/k8s/local-kind/README.md) являются источником истины для команд запуска.

## Подготовка полного dev-контура

```bash
git clone https://github.com/cms-lab-core/cms-labs-api.git
cd cms-labs-api
make dev-up
```

`make dev-up` запускает зависимости, создаёт или переиспользует kind, устанавливает Clabernetes и workspace-контроллеры и подготавливает единый development gateway.

## Процессы из исходников

Запустите в отдельных терминалах:

```bash
make dev-backend
make dev-seed
make dev-clabgate
make dev-front
```

Открывайте приложение через `http://127.0.0.1:18080`, а не напрямую через Vite: gateway сохраняет единый origin для API, cookies, iframe и WebSocket workspace-сервисов.

## Проверки

```bash
make test
make pre_commit
make security
```

Перед использованием команд сверяйтесь с документацией текущей ветки `cms-labs-api`: состав целей Makefile может изменяться вместе с архитектурой.

## Остановка

```bash
make dev-down
```

> **Нужна иллюстрация:** четыре терминала с backend, seed, Clabgate и frontend, рядом браузер на development gateway и pod лаборатории в kind.
