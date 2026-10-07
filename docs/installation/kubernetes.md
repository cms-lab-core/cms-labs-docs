# Установка в Kubernetes-кластер

Production-вариант устанавливается Helm-чартами в существующий Kubernetes-кластер.

## Предварительная архитектура

- системный namespace содержит CMS, Clabgate и контроллеры;
- каждая попытка получает отдельный namespace;
- Clabernetes управляет сетевыми узлами;
- terminal и capture устанавливаются рядом с ресурсами лаборатории контроллерами платформы;
- ingress направляет UI и workspace-трафик через единый публичный адрес.

## Зависимости

- Kubernetes и рабочий CNI;
- ingress controller;
- default StorageClass либо явно заданные классы;
- cert-manager или заранее подготовленные TLS Secrets;
- Clabernetes;
- доступ узлов к GHCR и реестрам сетевых образов.

## Каркас установки

```bash
# TODO: указать итоговый OCI URL и стабильную версию чарта
helm upgrade --install cms-labs \
  oci://ghcr.io/cms-lab-core/charts/cms-labs-api \
  --namespace cms-labs-system \
  --create-namespace \
  --values values.production.yaml
```

В production нельзя использовать `latest`: версии образов и чартов должны быть зафиксированы в values или lock-файле окружения.

## Проверка после установки

- rollout всех системных deployment завершён;
- CMS доступна по HTTPS;
- Clabgate проходит readiness и видит Kubernetes API;
- пробная попытка достигает состояния `active`;
- workspace grant открывает JupyterLab и terminal;
- checker возвращает структурированный результат;
- завершение попытки удаляет или архивирует ресурсы по политике курса.

> **Нужна иллюстрация:** production-схема из системного namespace, двух namespace попыток, ingress, database и Git/OCI registry.

## Что дописать

- таблицу values;
- RBAC и NetworkPolicy;
- sizing и autoscaling;
- внешнюю базу данных;
- backup/restore;
- rolling upgrade и rollback.
