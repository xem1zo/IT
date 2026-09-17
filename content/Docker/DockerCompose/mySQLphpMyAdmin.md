<div align="center">

# 🐳 Docker Compose: MySQL + phpMyAdmin

**Веб-приложение для администрирования MySQL/MariaDB через браузер**

[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-latest-6C78AF?style=for-the-badge&logo=phpmyadmin&logoColor=white)](https://www.phpmyadmin.net/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)

</div>

---

## 📖 О проекте

**phpMyAdmin** — веб‑приложение с открытым исходным кодом на **PHP** для администрирования **MySQL/MariaDB** через браузер. Предоставляет графический интерфейс для управления базами данных без необходимости писать **SQL**‑команды вручную.

---

## ⚠️ Подготовка перед запуском

Перед началом работы над этим проектом **проверьте другие запущенные у вас `docker-compose` приложения**:

```shell
docker compose ls
```

> 💡 **Совет:** Лучше остановить лишние контейнеры, чтобы снизить риск возникновения конфликтов использования портов!

---

## 📂 Шаг 1. Создание каталога проекта

### 🗂️ Структура проекта

```
mysql-pma-app/
└── compose.yaml
```

### ⚡ Создаём структуру одной bash-командой

```shell
mkdir -p mysql-pma-app && touch mysql-pma-app/compose.yaml && cd mysql-pma-app
```

---

## ⚙️ Шаг 2. Файл настроек композера `compose.yml`

```yaml
services:
  # Сервис базы данных MySQL
  mysql:
    # Используем официальный образ MySQL 8.0
    image: mysql:8.0
    # Контейнер будет автоматически перезапускаться, если он остановился или упал
    restart: unless-stopped
    environment:
      # Обязательные переменные окружения для MySQL
      MYSQL_ROOT_PASSWORD: root       # Пароль для root-пользователя
      MYSQL_DATABASE: my_database     # Имя базы данных, которая будет создана автоматически
      MYSQL_USER: my_user             # Имя дополнительного пользователя
      MYSQL_PASSWORD: my_password     # Пароль для дополнительного пользователя
    ports:
      # Пробрасываем порт 3306 хоста на порт 3306 в контейнере
      - "3306:3306"
    volumes:
      # Сохраняем данные базы данных в Docker-томе для персистентности
      - mysql_data:/var/lib/mysql
    networks:
      - mysql-pma-network

  # Сервис phpMyAdmin
  phpmyadmin:
    # Зависит от сервиса mysql, запустится после его готовности
    depends_on:
      - mysql
    # Используем официальный образ phpMyAdmin
    image: phpmyadmin/phpmyadmin:latest
    # Пробрасываем порт 8083 на хосте на порт 80 в контейнере
    ports:
      - "8083:80"
    restart: unless-stopped
    environment:
      # Переменные для подключения к серверу базы данных
      PMA_HOST: mysql        # Имя хоста MySQL-сервера (совпадает с именем сервиса)
      PMA_PORT: 3306         # Порт MySQL-сервера
      PMA_ARBITRARY: 1       # Разрешает подключаться к произвольному серверу
      UPLOAD_LIMIT: 300M     # Увеличивает лимит на загрузку файлов (для больших SQL-дампов)
    networks:
      - mysql-pma-network

# Определяем общую сеть для связи контейнеров
networks:
  mysql-pma-network:

# Определяем Docker-том для хранения данных базы данных
volumes:
  mysql_data:
```

---

## 🚀 Шаг 3. Установка и запуск проекта

В папке, где находится ваш `compose.yaml` файл, выполните команду для запуска всех сервисов в фоновом режиме:

```shell
docker compose up -d
```

> 📎 **Docker** начнёт скачивать необходимые образы и запускать контейнеры. Этот шаг может занять несколько минут.
>
> ⚙️ Параметр `-d` означает фоновый режим запуска контейнеров.

### 🔍 Проверка статуса

Дождитесь полной загрузки. Убедиться, что всё работает, можно командой:

```shell
docker compose ps -a
```

> ✅ Оба контейнера (`mysql` и `phpmyadmin`) должны иметь статус **Up**.

---

## 🌐 Шаг 4. Доступ к локальному сервису phpMyAdmin

<div align="center">

### [🚀 Открыть phpMyAdmin → http://localhost:8083](http://localhost:8083)

</div>

### 🔑 Данные для входа

| Параметр | Значение |
|---|---|
| **Сервер** | `mysql` (или `localhost:3306`) |
| **Пользователь** | `root` |
| **Пароль** | `root` |

### 📸 Скриншоты

![Screen 1](/content/Docker/DockerCompose/img/13.png)
![Screen 2](/content/Docker/DockerCompose/img/14.png)

---

## 🛠️ Шаг 5. Управление и полезные команды

> 📁 Находясь в папке `mysql-pma-app`

<details open>
<summary><b>1. 📜 Просмотр логов phpMyAdmin в реальном времени</b></summary>

```shell
docker compose logs -f phpmyadmin
```

- `-f` — режим ожидания (в режиме реального времени)

> 🛑 Чтобы выйти из режима просмотра логов, нажмите `Ctrl+C`.
</details>

<details open>
<summary><b>2. 📜 Просмотр логов MySQL в реальном времени</b></summary>

```shell
docker compose logs -f mysql
```

> 🛑 Чтобы выйти из режима просмотра логов, нажмите `Ctrl+C`.
</details>

<details open>
<summary><b>3. ⏸️ Приостановить запущенный контейнер</b></summary>

```shell
docker compose stop
```
</details>

<details open>
<summary><b>4. ▶️ Запустить приостановленный контейнер</b></summary>

```shell
docker compose start
```
</details>

<details open>
<summary><b>5. 🔄 Перезапустить контейнеры</b></summary>

```shell
docker compose restart
```
</details>

<details open>
<summary><b>6. ⚙️ Показать конфигурацию текущего проекта</b></summary>

```shell
docker compose config
```
</details>

<details open>
<summary><b>7. 🐚 Вход в контейнер MySQL</b></summary>

> ℹ️ Имя контейнера можно узнать командой `docker compose ps`

```shell
docker compose exec mysql bash
```

![Screen 3](/content/Docker/DockerCompose/img/15.png)

> 🚪 Выйти из контейнера можно командой `exit`.
</details>

---

## 🗑️ Шаг 6. Удаление проекта

> 📁 Находясь в папке `mysql-pma-app`

### 1️⃣ Остановка контейнеров этого проекта

```shell
docker compose down
```

### 2️⃣ Остановка с полным удалением всех данных (опционально)

```shell
docker compose down --volumes
```

или для краткости:

```shell
docker compose down -v
```

> ⚠️ **Будьте осторожны!** Эта команда удалит всё, что вы создали в проекте!

---

### 📌 Полное удаление проекта

Для полного удаления достаточно:
1. Остановить проект через `docker compose down` или `docker compose down --volumes`
2. Удалить Docker-образ
3. Удалить каталог проекта `mysql-pma-app`

### 🔧 Удалить образ проекта

```shell
docker image rm
```

### 📁 Выходим из каталога проекта

```shell
cd ..
```

### 🗑️ Удаляем каталог

```shell
rm -rf mysql-pma-app
```

---

<div align="center">

### ⭐ Если проект был полезен — поставьте звезду репозиторию!

**Сделано с ❤️ для удобной работы с Docker Compose**

---

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

</div>
