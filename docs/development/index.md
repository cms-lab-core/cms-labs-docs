# Выбор среды разработки

| Что меняете | Как запустить | Где работают компоненты |
| --- | --- | --- |
| Notebook, манифесты задания, Helm values, checker, terminal или capture | [Полный стенд в kind](kind.md) | CMS Labs и сервисы запускаются в kind из опубликованных образов. |
| Backend или Clabgate на Go, frontend на Vite, nginx gateway | [CMS Labs из исходников](api.md) | MySQL и Vault запускаются в Docker, API и Vite — на компьютере, gateway и учебные сервисы — в kind. |

```mermaid
flowchart LR
    Task["Задание и образы"] --> Published["Демо kind с опубликованными чартами"]
    Source["Go и Vite из исходников"] --> Gateway["Development gateway в kind"]
    Gateway --> Workspace["JupyterLab и устройства в kind"]
```

Для самой лабораторной используйте [контракт](../technical/lab-contract.md) и [руководство по подключению](../labs/authoring.md).
