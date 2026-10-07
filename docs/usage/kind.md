# Локальный запуск в kind

Локальный kind воспроизводит полный пользовательский контур: CMS, Clabgate, Clabernetes, лабораторную топологию, JupyterLab, terminal и checker.

## Предварительные требования

- Docker Engine или Docker Desktop;
- Git;
- достаточно CPU, RAM и диска для Kubernetes и сетевых узлов;
- возможность запуска privileged-контейнеров.

`kind`, `kubectl` и Helm устанавливаются bootstrap-скриптом в локальный cache репозитория, если их нет в системе.

## Запуск примера

```bash
git clone https://github.com/cms-lab-core/cms-labs-simple-task.git
cd cms-labs-simple-task
./scripts/demo up
```

После успешного запуска скрипт выводит URL интерфейса CMS Labs.

## Проверка и повторный запуск

```bash
./scripts/demo status
./scripts/demo resume
```

Проверьте:

- готовность системных deployment;
- создание namespace попытки;
- состояние Clabernetes topology;
- открытие CMS, JupyterLab и terminal;
- получение результата checker.

## Удаление

```bash
./scripts/demo down
```

Команда удаляет локальный kind-кластер вместе с данными демонстрационной попытки.

> **Нужна иллюстрация:** вывод `kubectl get pods -A` исправного стенда с разделением системного namespace и namespace попытки.
