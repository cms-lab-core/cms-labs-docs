# Диагностика

## Сессия не становится active

Проверьте по порядку:

1. событие попытки в CMS;
2. логи Clabgate;
3. создание namespace;
4. состояние topology и событий Clabernetes;
5. image pull и readiness Jupyter/checker/terminal;
6. лимиты ресурсов и admission policies.

## Workspace показывает invalid or expired grant

- проверьте время на узлах;
- убедитесь, что redirect endpoint обменивает grant один раз;
- проверьте cookie path для `/clabgate/workspace/<session>/...`;
- сравните TTL grant и кэш `auth_request`;
- исключите повторное использование старой ссылки.

## Терминал предлагает reconnect

- проверьте terminal broker и target-конфигурацию;
- убедитесь, что shell переживает отключение WebSocket;
- проверьте команду для типа узла (`bash`, `ash`, SR Linux CLI);
- проверьте workspace proxy и поддержку WebSocket ingress.

## JupyterLab не получает задание

- проверьте Git URL и revision;
- SHA коммита нельзя передавать как имя несуществующей ветки;
- проверьте путь notebook внутри workspace;
- изучите лог синхронизации до открытия `/lab/tree/...`.

> **Нужна иллюстрация:** дерево диагностики по симптомам: provisioning, 502, grant, terminal reconnect, Git sync.
