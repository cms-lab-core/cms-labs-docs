# Полный стенд разработчика в kind

Поднимите [локальный demo-kind](../usage/kind.md) и запустите попытку через каталог. Сценарий подходит для проверки манифестов, образов и совместимости контроллеров с рабочей топологией.

## Проверить релизы и контейнеры

```bash
helm --kube-context kind-cms-labs-demo list -A
kubectl --context kind-cms-labs-demo get topology -A
kubectl --context kind-cms-labs-demo -n cms-labs-system get deployments,pods
```

[Вывод Helm и kubectl из локального demo-kind](../assets/screenshots/kind-helm.jpg)

## Проверить локальный образ

Пример обновляет **frontend** только в локальном кластере. Подставьте каталог исходников `nextui-dashboard`, если находитесь в другом репозитории.

```bash
yarn --cwd nextui-dashboard install --frozen-lockfile
yarn --cwd nextui-dashboard build
docker build -t cms-labs/frontend:dev ./nextui-dashboard
kind load docker-image cms-labs/frontend:dev --name cms-labs-demo

kubectl --context kind-cms-labs-demo -n cms-labs-system patch deployment frontend \
  --type=strategic \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"frontend","image":"cms-labs/frontend:dev","imagePullPolicy":"IfNotPresent"}]}}}}'
kubectl --context kind-cms-labs-demo -n cms-labs-system rollout status deployment/frontend
```

`IfNotPresent` позволяет использовать загруженный образ внутри kind. Чтобы вернуться к опубликованной версии, повторите `./scripts/demo up` в репозитории примера. Для итераций с другим тегом обновляйте тег в загрузке и в deployment.

## Переопределить чарт

Команда `demo up` принимает `CMS_LABS_API_CHART`, `CMS_LABS_TERMINAL_CHART` и `CMS_LABS_CAPTURE_CHART`. Для OCI-чарта версию задаёт соответствующая переменная с суффиксом `_VERSION`. Значением переменной чарта может быть путь к локальному чарту.

```bash
CMS_LABS_TERMINAL_CHART=../cms-labs-terminal/charts/cms-labs-terminal ./scripts/demo up
```

После изменения откройте стенд, проверьте создание новой попытки, интерактивный терминал и отчёт checker. Для нескольких сервисов меняйте по одному компоненту и записывайте версию, которой воспроизвели проблему.
