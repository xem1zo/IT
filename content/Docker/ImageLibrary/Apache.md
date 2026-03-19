## Практическая работа на примере готового образа Apache (httpd) в Docker

> **Apache httpd** — популярный веб‑сервер.
>
> Никогда в разработке не используйте русские имена файлов и каталогов!  
> Никогда в разработке не используйте пробелы и спец.символы в именах файлов и каталогов!

Материал оформлен по логике примера с [Nginx](/content/Docker/ImageLibrary/Nginx.md).

## Этапы

### 1. Проверить Docker

Получить версию установленного Docker:

```shell
docker version
```

Если видите ошибку вида `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified`, то:

- запустите **Docker Desktop**
- дождитесь, пока он полностью включит engine
- повторите команду `docker version`

> Готовые образы берутся из сторонних источников: **Docker Hub** и т.д.

### 2. Подготовка Docker (чтобы начать работать с "чистого листа")

#### Посмотреть контейнеры

```shell
docker ps -a
```

#### Остановить все запущенные контейнеры

Linux/macOS/WSL (bash):

```shell
docker stop $(docker ps -q)
```

Windows PowerShell:

```shell
docker ps -q | ForEach-Object { docker stop $_ }
```

#### Удалить остановленные контейнеры

```shell
docker container prune
```

#### (Опционально) удалить ненужные образы

Показать образы:

```shell
docker images
```

Удалить неиспользуемые образы:

```shell
docker image prune -a
```

> Удаляйте только учебные контейнеры и образы, т.к. есть риск потерять важные данные, которые могут содержаться в контейнерах!

### 3. Поиск и получение готового образа Apache

Официальный образ Apache в Docker обычно называется `httpd`.

Поиск образа:

```shell
docker search httpd
```

Получить, создать и запустить Apache:

```shell
docker run -d --name my-apache -p 8081:80 httpd
```

`docker run` объединяет команды `docker pull`, `docker create` и `docker start`.

Если запуск не удался (например, контейнер с таким именем уже существует), проверьте список:

```shell
docker ps -a
```

Показать загруженные образы:

```shell
docker images
```

### 4. Проверить работу контейнера

Способ 1:

```shell
curl http://localhost:8081/
```

Способ 2 — открыть в браузере: [http://localhost:8081/](http://localhost:8081/)

Остановить контейнер:

```shell
docker stop my-apache
```

Перезапустить:

```shell
docker restart my-apache
```

### 5. Управление контейнером

#### Мониторинг

Список контейнеров:

```shell
docker ps -a
```

Подробности о контейнере:

```shell
docker inspect my-apache
```

Мониторинг ресурсов:

```shell
docker stats
```

> Выйти из мониторинга можно по `Ctrl+C`

Логи контейнера:

```shell
docker logs my-apache
```

Логи в режиме ожидания:

```shell
docker logs -f my-apache
```

> Выйти из логов можно по `Ctrl+C`

#### Войти в контейнер и изменить страницу

Зайти в контейнер:

```shell
docker exec -it my-apache bash
```

Если `bash` недоступен, попробуйте:

```shell
docker exec -it my-apache sh
```

Установить консольный редактор (например, `micro`):

```shell
apt update && apt install -y micro
```

Открыть файл `index.html` для редактирования:

```shell
micro /usr/local/apache2/htdocs/index.html
```

> Чтобы в веб‑странице поддерживался русский язык, добавьте тег `<meta charset="UTF-8">`.

Сохранить по `Ctrl+S` и выйти по `Ctrl+Q`.

Проверить результат: [http://localhost:8081/](http://localhost:8081/)

Выйти из контейнера:

```shell
exit
```

### 6. Остановка и удаление

Остановить контейнер:

```shell
docker stop my-apache
```

Удалить контейнер:

```shell
docker rm my-apache
```

При необходимости удалить образ `httpd`:

```shell
docker rmi httpd
```

### 7. (Дополнительно) Apache через Docker Compose

Готовый пример с пробросом порта и монтированием сайта лежит здесь:

- `/content/Docker/projects/apache/`

> Если вы обнаружили ошибку в этом тексте — сообщите пожалуйста автору!
