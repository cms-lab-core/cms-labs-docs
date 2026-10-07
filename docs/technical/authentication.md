# Аутентификация и контроль доступа

Пользователь проходит аутентификацию в CMS. Workspace-сервисы не должны самостоятельно доверять идентификаторам из URL.

## Пользовательский доступ

1. Frontend запрашивает у Clabgate короткоживущий workspace grant.
2. Clabgate проверяет CMS token и принадлежность попытки пользователю.
3. Browser переходит через промежуточный endpoint, который обменивает grant на защищённую cookie.
4. Ingress `auth_request` проверяет cookie с допустимым кэшированием.
5. Запрос передаётся только сервису текущей попытки.

## Service-to-service

JupyterLab и checker используют projected ServiceAccount token с отдельной audience и коротким сроком жизни. Они не получают kubeconfig и не могут обращаться к чужому namespace.

## Требования

- grants одноразовые или ограничены коротким TTL;
- cookie имеет `HttpOnly`, подходящий `SameSite` и `Secure` в production;
- проверка учитывает session ID и service ID;
- все отказы и административные подключения аудируются;
- секреты подписи ротируются без остановки сервиса.

> **Нужна иллюстрация:** sequence diagram обмена CMS token → grant → workspace cookie и отдельный поток Jupyter ServiceAccount token.
