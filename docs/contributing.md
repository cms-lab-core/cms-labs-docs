# Участие в документации

Документация хранится рядом с конфигурацией Zensical и публикуется автоматически.

## Локальный preview

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
zensical serve
```

Откройте `http://127.0.0.1:8000`.

## Проверка перед pull request

```bash
zensical build --clean --strict
docker build -t cms-labs-docs:dev .
```

## Правила изменения

- одна страница отвечает на одну задачу читателя;
- команды должны быть проверяемыми и содержать версию компонента;
- секреты и реальные access tokens запрещены;
- новая страница добавляется в `nav`;
- screenshot сопровождается alt-текстом;
- незавершённая часть помечается конкретным `TODO`, а не скрывается.

## Публикация

- push в `main` обновляет GitHub Pages;
- pull request только собирает и проверяет сайт;
- тег `vX.Y.Z` публикует Docker-образ `X.Y.Z` и `latest`;
- обычный push никогда не обновляет образ `latest`.
