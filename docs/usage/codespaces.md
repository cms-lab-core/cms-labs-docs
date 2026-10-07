# Запуск в GitHub Codespaces

Codespaces — самый простой способ открыть пример лаборатории: Docker и Kubernetes работают в удалённой среде GitHub, а пользователь получает готовую ссылку на CMS Labs.

## Запуск

1. Откройте репозиторий [`cms-labs-simple-task`](https://github.com/cms-lab-core/cms-labs-simple-task).
2. Нажмите **Code → Codespaces → Create codespace on main**.
3. Дождитесь завершения создания контейнера и `postCreateCommand`. Первый запуск занимает больше времени, потому что создаётся kind-кластер и устанавливаются Helm-чарты.
4. Откройте вкладку **Ports** в VS Code.
5. Перейдите по опубликованной ссылке порта `18080`.

Не закрывайте Codespace во время первоначальной установки. Рабочая среда должна открыться только после завершения bootstrap-команды.

## Полезные команды

```bash
./scripts/demo status
./scripts/demo resume
./scripts/demo open
```

- `status` показывает ресурсы готового стенда;
- `resume` продолжает запуск, если Codespace был остановлен;
- `open` печатает локальный путь к активной сессии. В Codespaces используйте внешний адрес из вкладки **Ports**, сохранив путь после порта.

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

> **Нужна иллюстрация:** последовательность из трёх скриншотов — кнопка создания Codespace, журнал bootstrap и вкладка Ports со ссылкой на CMS Labs.
