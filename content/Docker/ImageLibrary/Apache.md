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

![Скрин версии Docker](https://placehold.co/1200x675/111b2e/e6edf3.png?text=01_docker_version)

Если видите ошибку вида `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified`, то:

- запустите **Docker Desktop**
- дождитесь, пока он полностью включит engine
- повторите команду `docker version`

![Скрин ошибки Docker Desktop pipe](https://placehold.co/1200x675/111b2e/e6edf3.png?text=01_docker_desktop_pipe_error)

> Готовые образы берутся из сторонних источников: **Docker Hub** и т.д.

### 2. Подготовка Docker (чтобы начать работать с "чистого листа")

#### Посмотреть контейнеры

```shell
docker ps -a
```

![Скрин вывода docker ps -a](https://placehold.co/1200x675/111b2e/e6edf3.png?text=02_docker_ps_a)

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

![Скрин вывода docker container prune](https://placehold.co/1200x675/111b2e/e6edf3.png?text=02_docker_container_prune)

#### (Опционально) удалить ненужные образы

Показать образы:

```shell
docker images
```

![Скрин вывода docker images](https://placehold.co/1200x675/111b2e/e6edf3.png?text=02_docker_images)

Удалить неиспользуемые образы:

```shell
docker image prune -a
```

![Скрин вывода docker image prune -a](https://placehold.co/1200x675/111b2e/e6edf3.png?text=02_docker_image_prune_a)

> Удаляйте только учебные контейнеры и образы, т.к. есть риск потерять важные данные, которые могут содержаться в контейнерах!

### 3. Поиск и получение готового образа Apache

Официальный образ Apache в Docker обычно называется `httpd`.

Поиск образа:

```shell
docker search httpd
```

![Скрин вывода docker search httpd](https://placehold.co/1200x675/111b2e/e6edf3.png?text=03_docker_search_httpd)

Получить, создать и запустить Apache:

```shell
docker run -d --name my-apache -p 8081:80 httpd
```

![Скрин успешного docker run](https://placehold.co/1200x675/111b2e/e6edf3.png?text=03_docker_run_httpd)

`docker run` объединяет команды `docker pull`, `docker create` и `docker start`.

Если запуск не удался (например, контейнер с таким именем уже существует), проверьте список:

```shell
docker ps -a
```

![Скрин списка контейнеров](https://placehold.co/1200x675/111b2e/e6edf3.png?text=03_docker_ps_a_after_run)

Показать загруженные образы:

```shell
docker images
```

![Скрин списка образов](https://placehold.co/1200x675/111b2e/e6edf3.png?text=03_docker_images_after_pull)

### 4. Проверить работу контейнера

Способ 1:

```shell
curl http://localhost:8081/
```

![Скрин вывода curl](https://placehold.co/1200x675/111b2e/e6edf3.png?text=04_curl_localhost_8081)

Способ 2 — открыть в браузере: [http://localhost:8081/](http://localhost:8081/)

![Скрин Apache в браузере](https://placehold.co/1200x675/111b2e/e6edf3.png?text=04_browser_localhost_8081)

Остановить контейнер:

```shell
docker stop my-apache
```

![Скрин docker stop](https://placehold.co/1200x675/111b2e/e6edf3.png?text=04_docker_stop)

Перезапустить:

```shell
docker restart my-apache
```

![Скрин docker restart](https://placehold.co/1200x675/111b2e/e6edf3.png?text=04_docker_restart)

### 5. Управление контейнером

#### Мониторинг

Список контейнеров:

```shell
docker ps -a
```

![Скрин docker ps -a](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_ps_a)

Подробности о контейнере:

```shell
docker inspect my-apache
```

![Скрин docker inspect](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_inspect)

Мониторинг ресурсов:

```shell
docker stats
```

![Скрин docker stats](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_stats)

> Выйти из мониторинга можно по `Ctrl+C`

Логи контейнера:

```shell
docker logs my-apache
```

![Скрин docker logs](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_logs)

Логи в режиме ожидания:

```shell
docker logs -f my-apache
```

![Скрин docker logs -f](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_logs_f)

> Выйти из логов можно по `Ctrl+C`

#### Войти в контейнер и изменить страницу

Зайти в контейнер:

```shell
docker exec -it my-apache bash
```

![Скрин docker exec bash](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_exec_bash)

Если `bash` недоступен, попробуйте:

```shell
docker exec -it my-apache sh
```

![Скрин docker exec sh](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_docker_exec_sh)

Установить консольный редактор (например, `micro`):

```shell
apt update && apt install -y micro
```

![Скрин установки micro](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_install_micro)

Открыть файл `index.html` для редактирования:

```shell
micro /usr/local/apache2/htdocs/index.html
```

![Скрин редактирования index.html](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_edit_index_html)

> Чтобы в веб‑странице поддерживался русский язык, добавьте тег `<meta charset="UTF-8">`.

Сохранить по `Ctrl+S` и выйти по `Ctrl+Q`.

Проверить результат: [http://localhost:8081/](http://localhost:8081/)

![Скрин изменённой страницы в браузере](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_browser_changed_page)

Выйти из контейнера:

```shell
exit
```

![Скрин выхода exit](https://placehold.co/1200x675/111b2e/e6edf3.png?text=05_exit)

### 6. Остановка и удаление

Остановить контейнер:

```shell
docker stop my-apache
```

![Скрин docker stop](https://placehold.co/1200x675/111b2e/e6edf3.png?text=06_docker_stop)

Удалить контейнер:

```shell
docker rm my-apache
```

![Скрин docker rm](https://placehold.co/1200x675/111b2e/e6edf3.png?text=06_docker_rm)

При необходимости удалить образ `httpd`:

```shell
docker rmi httpd
```

![Скрин docker rmi httpd](https://placehold.co/1200x675/111b2e/e6edf3.png?text=06_docker_rmi_httpd)

### 7. (Дополнительно) Apache через Docker Compose

Готовый пример с пробросом порта и монтированием сайта лежит здесь:

- `/content/Docker/projects/apache/`

![Скрин docker compose up -d](https://placehold.co/1200x675/111b2e/e6edf3.png?text=07_docker_compose_up)

![Скрин сайта из compose в браузере](https://placehold.co/1200x675/111b2e/e6edf3.png?text=07_browser_compose)

> Если вы обнаружили ошибку в этом тексте — сообщите пожалуйста автору!
