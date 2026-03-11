## Apache (httpd) через Docker Compose

### Запуск

Из папки `content/Docker/projects/apache`:

```shell
docker compose up -d
```

Проверка:

- Откройте в браузере `http://localhost:8081/`
- Или:

```shell
curl http://localhost:8081/
```

### Где лежит сайт

Файлы сайта: `site/index.html`.

После редактирования HTML просто обновите страницу в браузере.

### Остановка и удаление

```shell
docker compose down
```
