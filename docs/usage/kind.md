# Локальный запуск в kind

Этот вариант поднимает демонстрационный CMS Labs, MySQL, Clabgate, Clabernetes и контроллеры workspace в одном локальном кластере. Для первого запуска понадобятся Git, работающий Docker и доступ к GHCR и публичному репозиторию задания. На macOS или Windows можно запустить пример в VS Code через **Dev Containers: Rebuild and Reopen in Container**. Для Docker выделите ресурсы, сопоставимые с профилем Codespaces примера — 4 CPU, 8 ГБ RAM и 32 ГБ диска.

## Запустить

```bash
git clone https://github.com/cms-lab-core/cms-labs-simple-task.git
cd cms-labs-simple-task
CMS_LABS_API_CHART_VERSION=1.20.5 ./scripts/demo up
```

Скрипт использует установленные kind, kubectl и Helm или скачивает недостающие инструменты в свой cache. Кластер по умолчанию называется `cms-labs-demo`, адрес интерфейса — `http://127.0.0.1:18080/`. При занятом порте выберите другой порт и отдельное имя кластера.

```bash
CMS_LABS_CLUSTER_NAME=cms-labs-practice CMS_LABS_FRONTEND_PORT=18081 \
  CMS_LABS_API_CHART_VERSION=1.20.5 ./scripts/demo up
```

Зайдите через вкладку **«Внутренний»** с учебными данными `admin@admin.com` / `admin`. В каталоге **«Лабораторные работы»** откройте **«Пример задания: SSH и SNMP»** и нажмите **«Запустить»**. Если прямая demo-ссылка сообщает, что попытка не найдена, откройте каталог и создайте её там. Учебные данные входа предназначены для изолированного демо. Для прямого запуска на компьютере можно добавить `listenAddress: "127.0.0.1"` в `extraPortMappings` файла `.cms-labs/kind.yaml` перед созданием кластера. [Настройки портов kind](https://kind.sigs.k8s.io/docs/user/configuration/#extra-port-mappings).

## Проверить

```bash
./scripts/demo status
helm --kube-context kind-cms-labs-demo list -A
```

Если выбрали другое имя, подставьте его в `CMS_LABS_CLUSTER_NAME` для команд `demo` и в суффикс `kind-...` для Helm и kubectl. Откройте вкладки **«Обзор»**, **«Топология»** и **«Задание»**, проверьте готовность узлов и открытие терминала. Checker можно запустить до настройки узлов, чтобы проверить появление отчёта. Для прохождения работы выполните инструкции notebook.

[Вывод kubectl из локального demo-kind](../assets/screenshots/kind-pods.jpg)

### Если checker не запускается в демо

В некоторых версиях demo-values отсутствует ServiceAccount `cms-labs-checker`. Это видно в событиях Job по сообщению `serviceaccount "cms-labs-checker" not found`. Для отдельного локального стенда есть [пример ролей checker](../assets/examples/demo-checker-rbac.yaml). Он ограничен namespace одной попытки.

1. Возьмите имя namespace из вкладки **«Обзор»**, например `lab-…`.
2. В скачанном файле замените оба значения `LAB_NAMESPACE` этим именем.
3. Оператор локального kind может применить файл к своему demo-контексту и запустить проверку снова. Для новой попытки потребуется привязка к её namespace.

```bash
kubectl --context kind-cms-labs-demo -n cms-labs-system get jobs
kubectl --context kind-cms-labs-demo -n cms-labs-system get events --sort-by=.lastTimestamp
```

## Повторить запуск или остановить

- `./scripts/demo resume` проверяет готовность и при необходимости повторяет запуск.
- `./scripts/demo status` показывает pod и топологии, включая namespace попытки.
- `./scripts/demo down` удаляет выбранный локальный кластер вместе с его данными. Сохраните нужные notebook перед удалением.

Если Helm или pod не готовы, начните с [диагностики](../technical/troubleshooting.md). Для группы пользователей используйте [установку в Kubernetes](kubernetes.md).
