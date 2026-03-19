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

![Скрин версии Docker](img/apache/01_docker_version.png)

Если видите ошибку вида `open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified`, то:

- запустите **Docker Desktop**
- дождитесь, пока он полностью включит engine
- повторите команду `docker version`

![Скрин ошибки Docker Desktop pipe](img/apache/01_docker_desktop_pipe_error.png)

> Готовые образы берутся из сторонних источников: **Docker Hub** и т.д.

### 2. Подготовка Docker (чтобы начать работать с "чистого листа")

#### Посмотреть контейнеры

```shell
docker ps -a
```

![Скрин вывода docker ps -a](img/apache/02_docker_ps_a.png)

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

![Скрин вывода docker container prune](img/apache/02_docker_container_prune.png)

#### (Опционально) удалить ненужные образы

Показать образы:

```shell
docker images
```

![Скрин вывода docker images](img/apache/02_docker_images.png)

Удалить неиспользуемые образы:

```shell
docker image prune -a
```

![Скрин вывода docker image prune -a](img/apache/02_docker_image_prune_a.png)

> Удаляйте только учебные контейнеры и образы, т.к. есть риск потерять важные данные, которые могут содержаться в контейнерах!

### 3. Поиск и получение готового образа Apache

Официальный образ Apache в Docker обычно называется `httpd`.

Поиск образа:

```shell
docker search httpd
```

![Скрин вывода docker search httpd](img/apache/03_docker_search_httpd.png)

Получить, создать и запустить Apache:

```shell
docker run -d --name my-apache -p 8081:80 httpd
```

![Скрин успешного docker run](img/apache/03_docker_run_httpd.png)

`docker run` объединяет команды `docker pull`, `docker create` и `docker start`.

Если запуск не удался (например, контейнер с таким именем уже существует), проверьте список:

```shell
docker ps -a
```

![Скрин списка контейнеров](img/apache/03_docker_ps_a_after_run.png)

Показать загруженные образы:

```shell
docker images
```

![Скрин списка образов](img/apache/03_docker_images_after_pull.png)

### 4. Проверить работу контейнера

Способ 1:

```shell
curl http://localhost:8081/
```

![Скрин вывода curl](img/apache/04_curl_localhost_8081.png)

Способ 2 — открыть в браузере: [http://localhost:8081/](http://localhost:8081/)

![Скрин Apache в браузере](img/apache/04_browser_localhost_8081.png)

Остановить контейнер:

```shell
docker stop my-apache
```

![Скрин docker stop](img/apache/04_docker_stop.png)

Перезапустить:

```shell
docker restart my-apache
```

![Скрин docker restart](img/apache/04_docker_restart.png)

### 5. Управление контейнером

#### Мониторинг

Список контейнеров:

```shell
docker ps -a
```

![Скрин docker ps -a](img/apache/05_docker_ps_a.png)

Подробности о контейнере:

```shell
docker inspect my-apache
```

![Скрин docker inspect](img/apache/05_docker_inspect.png)

Мониторинг ресурсов:

```shell
docker stats
```

![Скрин docker stats](img/apache/05_docker_stats.png)

> Выйти из мониторинга можно по `Ctrl+C`

Логи контейнера:

```shell
docker logs my-apache
```

![Скрин docker logs](img/apache/05_docker_logs.png)

Логи в режиме ожидания:

```shell
docker logs -f my-apache
```

![Скрин docker logs -f](img/apache/05_docker_logs_f.png)

> Выйти из логов можно по `Ctrl+C`

#### Войти в контейнер и изменить страницу

Зайти в контейнер:

```shell
docker exec -it my-apache bash
```

![Скрин docker exec bash](img/apache/05_docker_exec_bash.png)

Если `bash` недоступен, попробуйте:

```shell
docker exec -it my-apache sh
```

![Скрин docker exec sh](img/apache/05_docker_exec_sh.png)

Установить консольный редактор (например, `micro`):

```shell
apt update && apt install -y micro
```

![Скрин установки micro](img/apache/05_install_micro.png)

Открыть файл `index.html` для редактирования:

```shell
micro /usr/local/apache2/htdocs/index.html
```

![Скрин редактирования index.html](img/apache/05_edit_index_html.png)

> Чтобы в веб‑странице поддерживался русский язык, добавьте тег `<meta charset="UTF-8">`.

Сохранить по `Ctrl+S` и выйти по `Ctrl+Q`.

Проверить результат: [http://localhost:8081/](http://localhost:8081/)

![Скрин изменённой страницы в браузере](img/apache/05_browser_changed_page.png)

Выйти из контейнера:

```shell
exit
```

![Скрин выхода exit](img/apache/05_exit.png)

### 6. Остановка и удаление

Остановить контейнер:

```shell
docker stop my-apache
```

![Скрин docker stop](img/apache/06_docker_stop.png)

Удалить контейнер:

```shell
docker rm my-apache
```

![Скрин docker rm](img/apache/06_docker_rm.png)

При необходимости удалить образ `httpd`:

```shell
docker rmi httpd
```

![Скрин docker rmi httpd](img/apache/06_docker_rmi_httpd.png)

### 7. (Дополнительно) Apache через Docker Compose

Готовый пример с пробросом порта и монтированием сайта лежит здесь:

- `/content/Docker/projects/apache/`

![Скрин docker compose up -d](img/apache/07_docker_compose_up.png)

![Скрин сайта из compose в браузере](img/apache/07_browser_compose.png)

> Если вы обнаружили ошибку в этом тексте — сообщите пожалуйста автору!
