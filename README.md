# CMS Labs Documentation

Документация CMS Labs на [Zensical](https://zensical.org/).

## Локальный запуск

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
zensical serve
```

## Сборка

```bash
zensical build --clean --strict
docker build -t cms-labs-docs:dev .
docker run --rm -p 8080:8080 cms-labs-docs:dev
```

Сайт будет доступен на <http://127.0.0.1:8080>.

## Публикация

- GitHub Pages публикуется только из `main`;
- Docker-образ публикуется только по стабильному тегу `vX.Y.Z`;
- релиз создаёт `ghcr.io/cms-lab-core/cms-labs-docs:X.Y.Z` и обновляет `latest`.

## Лицензия

[MIT](LICENSE)
