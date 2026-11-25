# Запуск в GitHub Codespaces

Codespaces — самый простой способ открыть пример лаборатории: Docker и Kubernetes работают в удалённой среде GitHub, а пользователь получает готовую ссылку на CMS Labs.

## Запуск

1. Откройте репозиторий [`cms-labs-simple-task`](https://github.com/cms-lab-core/cms-labs-simple-task).
2. Нажмите **Code → Codespaces → Create codespace on main**.
3. Дождитесь завершения создания контейнера и `postCreateCommand`. Первый запуск занимает больше времени, потому что создаётся kind-кластер и устанавливаются Helm-чарты.
4. Откройте вкладку **Ports** в VS Code.
5. Перейдите по ссылке порта `18080`. Держите порт приватным и открывайте его из своей сессии GitHub.
6. Войдите через вкладку **«Внутренний»** с учебными данными `admin@admin.com` / `admin`. Перейдите в каталог и запустите пример **«SSH и SNMP»**. Если вы открыли Codespace из репозитория курса `lab-computer-network`, выберите нужную работу из его каталога.

Не останавливайте Codespace во время первоначальной установки. Рабочая среда должна открыться только после завершения bootstrap-команды.

[Перенаправление портов в Codespaces](https://docs.github.com/en/codespaces/developing-in-a-codespace/forwarding-ports-in-your-codespace)

## Полезные команды

```bash
./scripts/demo status
./scripts/demo resume
./scripts/demo open
```

- `status` показывает ресурсы готового стенда;
- `resume` продолжает запуск, если Codespace был остановлен;
- `open` печатает локальный путь к активной сессии. В Codespaces используйте внешний адрес из вкладки **Ports**. Если прямая ссылка на попытку не открывается, перейдите в каталог и создайте попытку там.

## Остановка

```bash
./scripts/demo down
```

Удаление Codespace также удалит локальный kind-кластер и несохранённые данные лаборатории. Скачайте notebook и другие артефакты заранее.

## Если интерфейс не открылся

- проверьте `./scripts/demo status`;
- убедитесь, что порт `18080` опубликован;
- выполните `./scripts/demo resume`;
- при изменении `.devcontainer/devcontainer.json` используйте **Codespaces: Rebuild Container**;
- изучите creation log, если `postCreateCommand` завершился ошибкой.

Подробнее о работе в интерфейсе написано в [инструкции для студента](student.md).

## Скриншоты

На кадрах показан запуск репозитория `lab-computer-network` с тем же портом CMS Labs `18080`.

1. [Форма создания Codespace](../assets/screenshots/codespaces-create.jpg).
2. [Журнал создания dev container](../assets/screenshots/codespaces-bootstrap.jpg).
3. [Вкладка Ports в VS Code](../assets/screenshots/codespaces-ports.jpg).
4. [CMS Labs после перехода по ссылке порта](../assets/screenshots/codespaces-cms.jpg).
