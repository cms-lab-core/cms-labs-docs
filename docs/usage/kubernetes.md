# Установка в существующий Kubernetes

Эта инструкция рассчитана на отдельную инсталляцию для группы пользователей. Подготовьте Kubernetes-кластер с рабочим DNS, CNI, default StorageClass для JupyterLab, ingress с TLS и отдельную MySQL. Узлы должны получать образы из GHCR и реестров учебных устройств. Если кластер ещё не создан, сначала проверьте сценарий в [локальном kind](kind.md).

Пример использует чарт CMS Labs **1.20.5**, Clabernetes **0.9.0**, terminal **2.0.1** и capture **0.1.2**. Эти версии чартов устанавливались вместе в локальном kind. Настройки Kubernetes ниже отделяют секреты и базу данных от Helm values, для внешнего доступа понадобится ваш DNS и ingress. Пример использует стандартный домен сервисов `cluster.local`.

[Скачать пример values.cluster.yaml](../assets/examples/values.cluster.yaml)

## 1. Проверить контекст и установить контроллеры

В командах предполагается, что вы выбрали нужный кластер. Проверьте имя и адрес API перед установкой. Если контроллеры уже есть, используйте установленные релизы и проверьте версию их CRD.

```bash
kubectl config current-context
kubectl cluster-info
kubectl get storageclass
export CMS_CONTEXT="$(kubectl config current-context)"

helm upgrade --install clabernetes \
  oci://ghcr.io/clabernetes/clabernetes/clabernetes \
  --version 0.9.0 --namespace c9s --create-namespace \
  --kube-context "$CMS_CONTEXT" --set ui.enabled=false --wait --timeout 5m

helm upgrade --install terminal oci://ghcr.io/cms-lab-core/charts/cms-labs-terminal \
  --version 2.0.1 --namespace cms-labs-system --create-namespace \
  --kube-context "$CMS_CONTEXT" --set controller.proxyNamespace=cms-labs-system --wait --timeout 5m

helm upgrade --install capture oci://ghcr.io/cms-lab-core/charts/cms-labs-capture \
  --version 0.1.2 --namespace cms-labs-system \
  --kube-context "$CMS_CONTEXT" --set controller.proxyNamespace=cms-labs-system --wait --timeout 5m
```

## 2. Подготовить конфигурацию и секреты

Выполняйте команды в папке с файлом values. Подготовьте файлы `backend.env` и `clabgate.env` из защищённого хранилища. Каждый параметр задаётся строкой `ИМЯ=значение`.

| Файл или объект | Что задать |
| --- | --- |
| `backend.env` | `DB_TYPE=mysql`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_SSL_MODE` и `DB_TABLE_PREFIX`. У пользователя БД должны быть права для миграций схемы. Настройки TLS и имя базы задаются вашей установкой MySQL. |
| `clabgate.env` | `CMS_LOGIN` и `CMS_PASSWORD` для будущей записи сервера в CMS, `WORKSPACE_AUTH_SECRET` как случайный ключ от 32 байт, `JUPYTER_IMAGE` и `CHECKER_IMAGE` с выбранными версиями или digest. При необходимости задайте `JUPYTER_STORAGE_SIZE` и токен чтения Git `TASK_REPOSITORY_TOKEN`. |
| `cms-jwt` | Приватный и публичный RSA-ключ для CMS. Сохраняйте ту же пару при обновлениях. |
| `cms-frontend-env` | `SYSTEM_DNS` равен адресу резолвера, доступного pod frontend. Обычно это ClusterIP сервиса `kube-dns`. Проверьте DNS в своей сети. |

```bash
kubectl --context "$CMS_CONTEXT" -n kube-system get svc kube-dns \
  -o jsonpath='{.spec.clusterIP}{"\n"}'

umask 077
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
openssl pkey -in private.pem -pubout -out public.pem

kubectl --context "$CMS_CONTEXT" -n cms-labs-system create secret generic cms-backend-env \
  --from-env-file=backend.env
kubectl --context "$CMS_CONTEXT" -n cms-labs-system create secret generic cms-clabgate-env \
  --from-env-file=clabgate.env
kubectl --context "$CMS_CONTEXT" -n cms-labs-system create secret generic cms-jwt \
  --from-file=private.pem --from-file=public.pem

CMS_DNS="$(kubectl --context "$CMS_CONTEXT" -n kube-system get svc kube-dns -o jsonpath='{.spec.clusterIP}')"
test -n "$CMS_DNS" && kubectl --context "$CMS_CONTEXT" -n cms-labs-system \
  create configmap cms-frontend-env --from-literal="SYSTEM_DNS=$CMS_DNS"
```

У Clabgate и checker разные ServiceAccount. В примере их cluster-wide роли нужны для работы с отдельными namespace попыток. Устанавливайте эти роли на выделенном учебном кластере или согласуйте их с оператором общей платформы.

## 3. Установить CMS и открыть интерфейс

```bash
CMS_CHART=oci://ghcr.io/cms-lab-core/cms-labs-api/charts/universal-chart

helm upgrade --install cms-labs "$CMS_CHART" \
  --version 1.20.5 --kube-context "$CMS_CONTEXT" --namespace cms-labs-system \
  --values values.cluster.yaml --wait --timeout 10m

kubectl --context "$CMS_CONTEXT" -n cms-labs-system get deployments,pods,svc,cronjob
kubectl --context "$CMS_CONTEXT" -n cms-labs-system port-forward svc/frontend 18080:80
```

Откройте `http://127.0.0.1:18080/` через локальный port-forward. Для новой базы CMS создаёт начальную учётную запись `admin@admin.com` / `admin`. Войдите и смените пароль через **Профиль → Сменить пароль**, затем настройте внешний доступ.

Ваш Ingress или HTTPRoute должен направлять все пути одного HTTPS-имени на `frontend:80` и пропускать WebSocket. Пример values оставляет сервисы типа `ClusterIP`. Backend, Clabgate, JupyterLab и терминалы доступны через frontend. Проверяйте рабочую область на внешнем HTTPS-адресе, где браузер принимает защищённую workspace-cookie.

В [примере Ingress](../assets/examples/ingress.yaml) замените имя хоста и класс Ingress на существующие, создайте TLS Secret или настройте его выпуск у своего провайдера. Для Gateway API используйте TLS listener и HTTPRoute на тот же Service. [Ingress в Kubernetes](https://kubernetes.io/docs/concepts/services-networking/ingress/).

## 4. Создать сервер и проверить первую работу

1. В [«Серверах»](../admin/servers.md) создайте активный сервер **K8S**. ClientID и токен должны совпадать с `CMS_LOGIN` и `CMS_PASSWORD` в Clabgate. URL должен вести к сервису этого Clabgate, например `http://clabgate.cms-labs-system.svc.cluster.local` для одного кластера.
2. Подключите опубликованный пример или [собственную работу](../labs/authoring.md). Для `cms-labs-simple-task` используйте Git URL `https://github.com/cms-lab-core/cms-labs-simple-task.git#main`, ключ checker `sdn_lab_5` и только что созданный сервер K8S.
3. В каталоге стартуйте одну пробную работу. Проверьте обзор, топологию, терминал, JupyterLab и получение отчёта checker. Скачайте notebook и завершите сессию.
4. Если курс работает через Moodle, настройте [регистрацию LTI](../admin/integrations.md), запустите работу из Moodle и проверьте отображение оценки в обеих системах.

В примере включён повтор синхронизации оценок через `grade-sync` каждые пять минут. Перед обновлениями и восстановлением смотрите [эксплуатацию](../technical/operations.md).

## Дополнительные настройки JupyterLab

Clabgate читает параметры pod из `/etc/clabgate/jupyter/config.yaml`, если файл смонтирован. Положите его в ConfigMap и смонтируйте каталог в контейнер Clabgate. `nodeSelector` задаёт метки узлов, а `extraAnnotations` копирует указанные строки в метаданные pod JupyterLab.

```yaml
extraAnnotations:
  lab.example.org/profile: "notebooks"
nodeSelector:
  kubernetes.io/os: linux
```

Сверьте метки с `kubectl get nodes --show-labels`. После обновления файла перезапустите Clabgate и проверьте результат на новой попытке. Для первичного монтажа можно взять за основу [конфигурацию Clabgate](https://github.com/cms-lab-core/cms-labs-api/blob/v1.20.5/k8s/values/_common/clabgate-values.yaml).
