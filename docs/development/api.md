# Разработка cms-labs-api из исходников

Монорепозиторий содержит backend, Clabgate, frontend и конфигурацию dev-gateway. Используйте Go **1.24.4**, Node.js **22**, Yarn **1.22.22**, Docker с Compose, kubectl, kind и Helm. Понадобится `sql-migrate` для миграций.

## Подготовить окружение

```bash
git clone --branch v1.20.5 https://github.com/cms-lab-core/cms-labs-api.git
cd cms-labs-api

go install github.com/rubenv/sql-migrate/...@v1.8.1
export PATH="$(go env GOPATH)/bin:$PATH"

corepack enable
corepack prepare yarn@1.22.22 --activate
yarn --cwd nextui-dashboard install --frozen-lockfile

test -e backend/.env || cp backend/.env.test backend/.env
test -e clabgate/.env || cp clabgate/.env.test clabgate/.env

make dev-up
```

`make dev-up` запускает MySQL и Vault в Compose, создаёт локальный кластер `cms-labs-local` и записывает отдельный kubeconfig `.local/kubeconfig`. Файлы `.env.test` содержат настройки изолированной тестовой среды. Адрес БД для запуска Go-процессов с хоста задайте через `DB_HOST=127.0.0.1`, потому что тестовый hostname по умолчанию доступен внутри контейнерной сети.

## Запустить процессы

Запустите команды из корня репозитория в отдельных терминалах. В терминале backend убедитесь, что `sql-migrate` доступен в `PATH`.

```bash
DB_HOST=127.0.0.1 LAB_CATALOG_ENABLED=true make dev-backend
```

```bash
DB_HOST=127.0.0.1 LAB_CATALOG_ENABLED=true make dev-seed
```

```bash
KUBECONFIG="$PWD/.local/kubeconfig" make dev-clabgate
```

```bash
make dev-front
```

`dev-seed` заполняет тестовую базу и завершается. Можно передать файл каталога через `make dev-seed DEMO_CATALOG="$PWD/k8s/local-kind/labs.example.json"`.

Откройте `http://127.0.0.1:18080/`. Development gateway объединяет API backend на `5000`, Clabgate на `5001`, Vite на `5183` и workspace в одном origin. Если nginx-шаблон менялся, повторите `make dev-cluster-up`.

## Проверить и остановить

```bash
kubectl --kubeconfig .local/kubeconfig --context kind-cms-labs-local get pods -A
yarn --cwd nextui-dashboard lint
yarn --cwd nextui-dashboard types
yarn --cwd nextui-dashboard build
```

Инструкция по запуску CI и тестов из исходников находится в [k8s/local-kind/README.md](https://github.com/cms-lab-core/cms-labs-api/blob/v1.20.5/k8s/local-kind/README.md). Остановите процессы Go и Vite в их терминалах, затем выполните `make dev-down`, чтобы удалить локальное окружение. Сохраните нужные данные стенда заранее.
