# Установка на виртуальную машину через cloud-init

Одноузловая VM подходит для демонстрации, пилотного курса или изолированного учебного сервера. Это не замена отказоустойчивому production-кластеру.

## Предлагаемая схема

1. Cloud-провайдер создаёт Ubuntu VM.
2. `cloud-init` устанавливает container runtime и одноузловой Kubernetes.
3. Helm устанавливает CMS Labs и зависимости.
4. DNS указывает на VM, TLS выпускается автоматически или передаётся готовым Secret.
5. Каталог лабораторных загружается seed-задачей CMS.

> **Нужна иллюстрация:** схема одной VM: ingress → CMS/Clabgate → namespace лабораторий; отдельно показать persistent volume и внешний Git/OCI registry.

## Каркас cloud-init

```yaml
#cloud-config
package_update: true
packages:
  - ca-certificates
  - curl

runcmd:
  # TODO: установить выбранный Kubernetes-дистрибутив и зафиксировать версию
  # TODO: установить Helm и настроить GHCR
  # TODO: установить cms-labs-api chart с production values
  - [sh, -c, "echo 'CMS Labs bootstrap placeholder'"]
```

## Что должно задаваться извне

- доменное имя и email для TLS;
- storage class и размеры volumes;
- секреты базы данных и JWT;
- OIDC/LTI параметры;
- версии Helm-чартов;
- URL каталога лабораторных;
- резервное копирование.

## Критерии готовности шаблона

- повторный запуск не повреждает установленный контур;
- секреты не находятся в публичном user-data;
- версии компонентов зафиксированы;
- есть health-check после установки;
- документированы обновление и удаление.
