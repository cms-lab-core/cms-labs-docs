# Архитектура CMS Labs

CMS управляет пользователями, маршрутами, попытками и оценками. Clabgate управляет жизненным циклом Kubernetes-сессии. Quota, условия admission и версии компонентов задаются при развёртывании платформы.

```mermaid
flowchart LR
    Browser["Браузер"]
    Moodle["Moodle или другая LMS"]
    Git["Git с лабораторными"]
    OCI["OCI-реестр"]
    K8s["Kubernetes API"]
    C9s["Clabernetes"]
    DB["MySQL"]
    subgraph System["Системный namespace"]
        Front["Frontend и nginx"]
        Core["CMS backend"]
        Gate["Clabgate"]
    end
    subgraph Attempt["Namespace lab-…"]
        Devices["Узлы и линки"]
        Jupyter["JupyterLab и PVC"]
        Services["Terminal и capture"]
    end
    Browser -->|HTTPS и WebSocket| Front
    Moodle <-->|LTI и AGS| Core
    Front -->|CMS API| Core
    Front -->|Session и workspace auth| Gate
    Core --> DB
    Gate -->|Манифесты и Git revision| Git
    Gate -->|Создание и наблюдение| K8s
    K8s --> C9s
    C9s --> Devices
    K8s --> Jupyter
    K8s --> Services
    OCI -->|Образы контейнеров| K8s
    Front -->|Авторизованный workspace| Jupyter
    Front -->|Терминал и PCAP| Services
    Services --> Devices
```

- Каждая попытка получает свой namespace. Clabgate применяет рабочие манифесты и следит за готовностью JupyterLab и топологии.
- Checker запускается отдельным Job. Его namespace, ServiceAccount и образ задаёт оператор. Clabgate прикрепляет результат к попытке.
- Nginx принимает запросы браузера на одном origin. Доступ к JupyterLab, терминалу и capture проходит через проверку workspace-cookie.
- В production внешний вход направляется на frontend. Backend, Clabgate и workspace-сервисы могут оставаться внутри кластера.

[Взаимодействие компонентов](components.md) · [Жизненный цикл](session-lifecycle.md) · [Установка и настройки](../usage/kubernetes.md)
