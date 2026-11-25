# Компоненты

| Компонент | Ответственность | Область установки |
| --- | --- | --- |
| CMS backend | пользователи, каталог, попытки, LTI и оценки | системный namespace |
| Frontend | каталог и рабочий интерфейс лаборатории | системный namespace |
| Clabgate | жизненный цикл сессии, grants и workspace proxy | системный namespace |
| Clabernetes | преобразование topology в Kubernetes workloads | кластер |
| JupyterLab | notebook задания и рабочие файлы | namespace попытки |
| Terminal | долгоживущие терминальные сессии узлов | namespace попытки |
| Checker | автоматические проверки и структурированные результаты | namespace попытки |
| Capture | управляемый захват PCAP | namespace попытки/узлы |

## Границы ответственности

Clabgate не должен содержать реализацию терминала или анализатора трафика. Он проверяет право доступа, связывает запрос с попыткой и маршрутизирует его к сервису, развёрнутому контрактом лаборатории.

## Обмен данными

| Кто обращается | Куда | Протокол и назначение |
| --- | --- | --- |
| Браузер | Frontend | HTTPS для UI и API, WebSocket для интерактивных workspace-сервисов. |
| Frontend | Backend и Clabgate | HTTP внутри кластера. Nginx сохраняет общий origin для браузера. |
| Clabgate | Kubernetes API | Создание namespace, ресурсов попытки и checker Job. |
| Clabgate | Git | Чтение шаблонов и определение ревизии задания. |
| Terminal и capture | Сетевые узлы | Kubernetes API и средства захвата платформы. |
| Moodle | CMS backend | Вход и запуск элемента курса по LTI. |
| CMS backend | Moodle | Отправка оценки через Assignment and Grade Services. |

## Исходники

- [CMS backend, frontend и Clabgate](https://github.com/cms-lab-core/cms-labs-api)
- [JupyterLab](https://github.com/cms-lab-core/cms-labs-jupyter) · [Терминалы](https://github.com/cms-lab-core/cms-labs-terminal) · [Capture](https://github.com/cms-lab-core/cms-labs-capture)
- [Checker](https://github.com/cms-lab-core/cms-labs-checker) · [Clabernetes](https://github.com/srl-labs/clabernetes)
