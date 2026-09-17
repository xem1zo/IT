<div align="center">

# 🐳 Docker Compose проект с Joomla

**Бесплатная CMS с открытым исходным кодом на PHP и JavaScript**

[![Joomla](https://img.shields.io/badge/Joomla-CMS-5091CD?style=for-the-badge&logo=joomla&logoColor=white)](https://www.joomla.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![MariaDB](https://img.shields.io/badge/MariaDB-11.5.2-003545?style=for-the-badge&logo=mariadb&logoColor=white)](https://mariadb.org/)

</div>

---

## 📖 О проекте

**Joomla!** (произносится «джу́мла») — бесплатная система управления контентом (CMS) с открытым исходным кодом, написанная на **PHP** и **JavaScript**. Использует в качестве хранилища базы данных **MySQL** или другие реляционные СУБД.

> ℹ️ *Админка и фронтэнд работают, но заюзать подробней пока не удалось.*

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
joomla-docker/
└── compose.yml
```

### ⚡ Создаём каталог одной командой в Git-Bash

```shell
mkdir -p joomla-docker && touch joomla-docker/compose.yaml && cd joomla-docker
```

---

## ⚙️ Шаг 2. Содержимое файла конфигурации

Создаём и редактируем файл настроек композера средствами **VS Code** или через **Git-Bash**.

> 📌 Файл называется `compose.yaml` (современный стандарт) или `docker-compose.yml` (для совместимости со старыми версиями Docker Compose).

### 📝 Версия 1

```yaml
services:
  # Сервис базы данных MariaDB
  db:
    # Используем официальный образ MariaDB 11.5.2
    image: mariadb:11.5.2
    # Контейнер автоматически перезапускается, если он остановился или упал
    restart: unless-stopped
    environment:
      # Обязательные переменные окружения для базы данных
      MYSQL_ROOT_PASSWORD: example_root_password
      MYSQL_DATABASE: joomla_db
      MYSQL_USER: joomla_user
      MYSQL_PASSWORD: joomla_password
    volumes:
      # Сохраняем данные базы данных в Docker-томе для персистентности
      - db_data:/var/lib/mysql
    networks:
      - joomla-network

  # Сервис Joomla
  joomla:
    # Зависит от сервиса db, запустится только после того, как база данных будет готова
    depends_on:
      - db
    # Используем официальный образ Joomla с Apache
    image: joomla:latest
    # Пробрасываем порт 8082 на хосте на порт 82 в контейнере
    ports:
      - "8082:80"
    restart: unless-stopped
    environment:
      # Переменные окружения для подключения Joomla к базе данных
      JOOMLA_DB_HOST: db:3306
      JOOMLA_DB_USER: joomla_user
      JOOMLA_DB_PASSWORD: joomla_password
      JOOMLA_DB_NAME: joomla_db
    volumes:
      # Монтируем директорию с данными Joomla для сохранения контента, плагинов и тем
      - joomla_data:/var/www/html
    networks:
      - joomla-network

# Определяем общую сеть для связи контейнеров
networks:
  joomla-network:

# Определяем Docker-тома для хранения данных
volumes:
  db_data:
  joomla_data:
```

---

## 🚀 Шаг 3. Установка и запуск проекта

Находясь в каталоге проекта `joomla-docker`, выполните:

### ▶️ Запуск всех сервисов

```shell
docker compose up -d
```

> 📎 `-d` — запуск в фоновом режиме (detached)

### 🔍 Проверка статуса

```shell
docker compose ls
```

```shell
docker compose ps -a
```

### 📜 Просмотр логов

**Joomla:**
```shell
docker compose logs -f joomla
```

**MySQL:**
```shell
docker compose logs db
```

### 🌐 Проверка сети (опционально)

```shell
docker network inspect joomla-docker_joomla-network
```

---

## 🌐 Шаг 4. Процесс установки Joomla

### 🔗 Открыть веб-установщик

<div align="center">

### [🚀 Запустить веб-установщик Joomla → http://localhost:8082](http://localhost:8082)

</div>

Вы перейдёте на стандартную страницу мастера установки **Joomla**. Вас попросят выполнить несколько шагов:

### 1️⃣ Выбор языка установщика
Например, `Русский` или `English`.
> ⚠️ *У автора русский не установился!*

### 2️⃣ Проверка предустановки
Установщик проверит, что серверное окружение соответствует требованиям **Joomla**. Всё должно быть зелёным. ✅

### 3️⃣ Настройка базы данных

| Параметр | Значение |
|---|---|
| **Тип базы данных** | `MySQLi` или `PDO MySQL` (подойдёт любой) |
| **Имя сервера баз данных** | `db` (имя сервиса из `compose.yml`) |
| **Имя пользователя** | `joomla_user` |
| **Пароль к БД** | `joomla_password` |
| **Имя базы данных** | `joomla_db` |
| **Префикс таблиц** | Оставить по умолчанию или изменить для безопасности |

### 4️⃣ Настройка веб-сайта

| Параметр | Значение |
|---|---|
| **Название сайта** | Придумайте любое название |
| **Ваш E-mail** | Укажите свой email |
| **Имя администратора** | Придумайте имя для входа в админ-панель |
| **Пароль администратора** | Надёжный пароль |

### 5️⃣ Установка

После ввода всех данных нажмите **«Установить»**. Joomla создаст все необходимые таблицы в базе данных и завершит настройку.

> ⚠️ **Важно!** После завершения вы увидите окно с вашими данными администратора. Для продолжения работы **удалите папку `installation`**, следуя важному примечанию на экране установщика.

### 🎉 Готово!

Теперь ваш сайт доступен по адресам:

| Ресурс | Ссылка |
|---|---|
| 🌐 **Joomla сайт** | [http://localhost:8082](http://localhost:8082) |
| 🔐 **Админ-панель** | [http://localhost:8082/administrator](http://localhost:8082/administrator) |

### 📸 Скриншоты установки

![Screen 1](/Mynotes/docker_compose/img/297a283d-40ba-413e-a6c3-68596e3a77ef.png)
![Screen 2](/Mynotes/docker_compose/img/179deeea-df1e-4664-a2ca-dfdf1b926d13.png)
![Screen 3](/Mynotes/docker_compose/img/7b4ee820-dc68-48b2-8a37-8df2df65aee5.png)
![Screen 4](/Mynotes/docker_compose/img/dd63e5a6-71b1-47f0-b499-6bf2802ed6ff.png)
![Screen 5](/Mynotes/docker_compose/img/eda38812-5f8f-429f-832c-c4f75e9d1daa.png)
![Screen 6](/Mynotes/docker_compose/img/f879e867-c0f5-494d-a760-45e7a20e463a.png)

---

## 🛠️ Шаг 5. Управление и полезные команды

> 📁 Находясь в папке `joomla-docker`

<details open>
<summary><b>1. 📜 Просмотр логов Joomla в реальном времени</b></summary>

```shell
docker compose logs -f joomla
```

- `-f` — режим ожидания (в режиме реального времени)

> 🛑 Чтобы выйти из режима просмотра логов, нажмите `Ctrl+C`.
</details>

<details open>
<summary><b>2. 📜 Просмотр логов базы данных в реальном времени</b></summary>

```shell
docker compose logs -f db
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

---

## 🗑️ Шаг 6. Удаление проекта

### 1️⃣ Переходим в папку проекта

```shell
cd joomla-docker
```

### 2️⃣ Останавливаем и удаляем контейнеры вместе с volumes

```shell
docker compose down --volumes
```

или короче:

```shell
docker compose down -v
```

### 3️⃣ Выходим из каталога проекта

```shell
cd ..
```

### 4️⃣ Удаляем папку проекта

**Для Linux:**
```shell
sudo rm -rf joomla-docker
```

**Для Windows** (без `sudo`):
```shell
rm -rf joomla-docker
```

---

<div align="center">

### ⭐ Если проект был полезен — поставьте звезду репозиторию!

**Сделано с ❤️ для удобной работы с Docker Compose**

---

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

</div>
