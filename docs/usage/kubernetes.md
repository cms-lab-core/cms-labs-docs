# Использование в Kubernetes-кластере

Этот вариант предназначен для общей инсталляции: учебной группы, пилотного сервера или production.

## Предварительные требования

- существующий Kubernetes-кластер и рабочий CNI;
- ingress controller;
- default StorageClass либо явно заданные классы;
- cert-manager или заранее подготовленные TLS Secrets;
- DNS-имена для CMS и workspace-маршрутов;
- доступ узлов к GHCR и реестрам сетевых образов.

## Установка

Платформа и её контроллеры устанавливаются опубликованными OCI Helm-чартами. Для production используйте фиксированный SemVer, а не `latest`.

```bash
# TODO: заменить X.Y.Z на проверенную совместимую версию релиза
helm upgrade --install cms-labs \
  oci://ghcr.io/cms-lab-core/cms-labs-api/charts/universal-chart \
  --version X.Y.Z \
  --namespace cms-labs-system \
  --create-namespace \
  --values values.production.yaml
```

Итоговый values-файл должен задавать database, JWT/OIDC/LTI, ingress, TLS, storage, каталог лабораторных и версии workspace-компонентов.

## Одноузловая VM и cloud-init

Виртуальная машина не является отдельным способом установки CMS Labs. `cloud-init` может подготовить одноузловой Kubernetes, после чего применяется тот же Helm-сценарий.

```yaml
#cloud-config
package_update: true
packages:
  - ca-certificates
  - curl

runcmd:
  # TODO: установить зафиксированную версию одноузлового Kubernetes
  # TODO: установить Helm, настроить DNS/TLS и применить production values
  - [sh, -c, "echo 'Kubernetes bootstrap placeholder'"]
```

Секреты нельзя размещать в публичном `user-data`: передавайте их через secret manager провайдера или создавайте после bootstrap.

## Проверка после установки

- rollout системных deployment завершён;
- CMS доступна по HTTPS;
- Clabgate видит Kubernetes API;
- тестовая попытка достигает `active`;
- JupyterLab, terminal и checker открываются через workspace grant;
- завершение попытки освобождает ресурсы согласно политике курса.

> **Нужна иллюстрация:** production-схема системного namespace, двух namespace попыток, ingress, database, Git и OCI registry.
