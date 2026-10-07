# Обзор архитектуры

CMS Labs разделяет управление учебным процессом, управление Kubernetes-сессией и сервисы конкретной лаборатории.

## Уровни системы

1. **Учебный уровень:** CMS, пользователи, курсы, LTI, попытки и оценки.
2. **Control plane лабораторий:** Clabgate, выдача grant, применение контракта задания и наблюдение за состоянием.
3. **Оркестрация:** Kubernetes, Clabernetes и namespace попытки.
4. **Workspace:** JupyterLab, terminal, checker, capture и сетевые узлы.

```text
Browser
  │
  ▼
CMS / Frontend ─── Clabgate ─── Kubernetes API
                          │
                          ▼
                 Namespace попытки
                  ├─ topology nodes
                  ├─ JupyterLab
                  ├─ terminal
                  ├─ checker
                  └─ capture
```

> **Нужна иллюстрация:** полноценная C4 Container-диаграмма с границами browser, system namespace, attempt namespace и внешними Moodle/LTI, Git и GHCR.

## Основные принципы

- одна попытка изолирована отдельным namespace;
- JupyterLab не получает kubeconfig;
- доступ к workspace выдаётся после проверки пользователя и попытки;
- манифест лаборатории хранится вместе с заданием;
- terminal и capture имеют собственные API и жизненный цикл;
- checker возвращает машинно-читаемый результат.
