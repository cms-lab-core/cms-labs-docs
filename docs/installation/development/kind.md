# Разработка в локальном Kubernetes (kind)

Этот режим запускает полный интеграционный контур в Kubernetes-кластере внутри Docker.

## Предварительные требования

- Docker;
- `kind`, `kubectl` и Helm;
- достаточно CPU, RAM и диска для узлов лаборатории;
- возможность запуска privileged-контейнеров.

## Ожидаемый сценарий

Референсный сценарий находится в репозитории `cms-labs-simple-task`:

```bash
git clone https://github.com/cms-lab-core/cms-labs-simple-task.git
cd cms-labs-simple-task
./scripts/demo up
```

Скрипт должен создать kind-кластер, установить платформу Helm-чартами, загрузить пример лаборатории и вывести URL интерфейса.

## Проверка

```bash
./scripts/demo status
```

Проверьте:

- готовность системных deployment;
- создание namespace попытки;
- состояние Clabernetes topology;
- открытие CMS, JupyterLab и terminal;
- получение результата checker.

## Остановка

```bash
./scripts/demo down
```

> **Нужна иллюстрация:** вывод `kubectl get pods -A` для исправного стенда с визуальным разделением системного namespace и namespace попытки.

## Что дописать

- минимальные ресурсы для amd64 и arm64;
- локальные registry mirrors и загрузка dev-образов;
- отладка ingress/workspace proxy;
- работа с локальными checkout компонентов.
