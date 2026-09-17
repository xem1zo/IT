<div align="center">

<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original.svg" width="90" alt="PostgreSQL Logo"/>

# 🐘 PostgreSQL в Docker Compose

### *Объектно-реляционная СУБД с открытым исходным кодом*

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![SQL](https://img.shields.io/badge/SQL-Ready-CC2927?style=for-the-badge&logo=sqlite&logoColor=white)](https://ru.wikipedia.org/wiki/SQL)

</div>

---

> 🧭 **Навигация по гайду**
>
> | 🗂️ Этап | 📌 Что делаем |
> |---|---|
> | 🏗️ [Структура проекта](#-1-структура-проекта) | Готовим папки и файлы |
> | ⚙️ [Конфигурация](#-2-файл-docker-composeyml) | Пишем `docker-compose.yml` |
> | 🗄️ [init.sql](#-3-файл-scriptsinitssql) | Инициализируем БД |
> | 🚀 [Запуск](#-4-запуск-и-управление-postgresql-в-docker) | Поднимаем контейнер |
> | 🛠️ [Управление БД](#-5-управление-бд-в-docker-контейнере) | Подключаемся к Postgres |
> | 🗑️ [Удаление](#-6-удалить-установленный-контейнер-с-postgressql) | Чистим за собой |

---

## ⚠️ Пре-флайт проверка

> 🛑 **СТОП! Прежде чем начать!**
>
> Проверьте, не запущены ли у вас другие `docker-compose` проекты — они могут конфликтовать за порты.

```shell
docker compose ls
```

> 💡 **Совет от автора:** Лучше остановить лишние контейнеры. Свободные порты = счастливый разработчик.

---

## 🏗️ 1. Структура проекта

```
📦 postgres-docker-project/
├── 📁 data/                 ┐
├── 📁 scripts/              │  🗃️ Данные, SQL-скрипты
├── 📁 backups/              │  и бэкапы БД
└── 📄 docker-compose.yml    ┘  🎛️ Главный конфиг
```

### ⚡ Создаём всю структуру одной командой

```shell
mkdir -p postgres-docker-project/{data,scripts,backups} && \
touch postgres-docker-project/docker-compose.yml postgres-docker-project/scripts/init.sql && \
cd postgres-docker-project
```

> 🎯 Вжух — и вся структура готова! Осталось только заполнить файлы.

---

## ⚙️ 2. Файл `docker-compose.yml`

> 🧩 **Как это читать:** каждый блок снабжён комментарием прямо в коде. Читайте сверху вниз — как конструктор.

```yaml
# ═══════════════════════════════════════════════
#  Секция services — список всех контейнеров
# ═══════════════════════════════════════════════
services:

  # 🐘 Сервис PostgreSQL (логическое имя внутри docker-compose)
  postgres:

    # 📦 Образ: postgres версии 15 (скачается автоматически)
    image: postgres:15

    # 🏷️ Имя контейнера (будет видно в `docker ps`)
    container_name: my-postgres

    # 🌱 Переменные окружения при старте
    environment:
      POSTGRES_DB: mydatabase        # 🗄️ Создать БД при первом запуске
      POSTGRES_USER: myuser          # 👤 Создать суперпользователя
      POSTGRES_PASSWORD: mypassword  # 🔑 Установить пароль

    # 🔌 Проброс портов: "хост:контейнер"
    ports:
      - "5432:5432"                  # → localhost:5432

    # 💾 Тома (сохранение данных между перезапусками)
    volumes:
      - ./data:/var/lib/postgresql/data                          # 🗃️ Данные БД
      - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql  # 📜 Автоинициализация
      - ./backups:/backups                                       # 📤 Бэкапы

    # 🔄 Политика перезапуска
    restart: unless-stopped          # Всегда перезапускать, кроме ручной остановки

    # ❤️ Healthcheck — проверка живости сервиса
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydatabase"]  # 🩺 Проверка готовности
      interval: 30s                  # ⏱️ Интервал: 30 секунд
      timeout: 10s                   # ⌛ Таймаут: 10 секунд
      retries: 3                     # 🔁 3 попытки перед пометкой `unhealthy`
```

---

## 🗄️ 3. Файл `scripts/init.sql`

> 🎬 Этот скрипт **автоматически выполнится** PostgreSQL при первом старте.

```sql
-- ═══════════════════════════════════════════════
--  🚀 Инициализация базы данных
-- ═══════════════════════════════════════════════

-- 🆕 Создаём дополнительную БД
CREATE DATABASE app_db;

-- 👤 Создаём дополнительного пользователя
CREATE USER app_user WITH PASSWORD 'app_password';

-- 🎟️ Выдаём права
GRANT ALL PRIVILEGES ON DATABASE app_db TO app_user;

-- 🔀 Переключаемся на основную БД
\c mydatabase;

-- 📋 Создаём тестовую таблицу
CREATE TABLE IF NOT EXISTS users (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 🌱 Вставляем тестовые данные
INSERT INTO users (name, email) VALUES
    ('Иван Иванов',   'ivan@example.com'),
    ('Мария Петрова', 'maria@example.com')
ON CONFLICT (email) DO NOTHING;
```

---

## 🚀 4. Запуск и управление PostgreSQL в Docker

### ▶️ Поднимаем контейнер

```shell
docker compose up -d
```

> 🎛️ `-d` = **detached**, запуск в фоне.
>
> ⚠️ Без `-d` контейнер запустится в интерактивном режиме, и остановить его можно через **`Ctrl+C`**.

### 🔍 Проверяем состояние

```shell
docker compose ps
```

### 📜 Читаем логи

```shell
docker compose logs postgres
```

### 🛑 Останавливаем

<table>
<tr>
<td width="50%">

**Полная остановка + удаление контейнеров:**

```shell
docker compose down
```

> 💾 **Данные БД не удалятся!** Тома останутся.

</td>
<td width="50%">

**Мягкая остановка (без удаления):**

```shell
docker compose stop
```

> ▶️ Запустить снова: `docker compose start`

</td>
</tr>
</table>

### 🧾 Показываем конфигурацию

```shell
docker compose config
```

> 📁 **Правило хорошего тона:** каждый новый контейнер — в своей папке. Это обеспечивает максимальную изоляцию проектов.

---

## 🛠️ 5. Управление БД в Docker-контейнере

### 🔌 Подключаемся к БД

```shell
docker exec -it my-postgres psql -U myuser -d mydatabase
```

> 🚪 **Выход из psql:** введите `EXIT` и нажмите Enter.

### 🌐 Попытка подключиться из браузера

Открываем в браузере: [`localhost:5432`](localhost:5432)

> 📄 **Результат:** пустая страница
> *«Соединение с сайтом localhost было успешно установлено, но он не отправил ничего в ответ.»*
>
> ✅ **Это нормально!** PostgreSQL не отдаёт HTML — он ждёт SQL-запросов, а не HTTP-запросов.

### ⏯️ Останавливаем / запускаем

<table>
<tr>
<td>

**Пауза:**
```shell
docker compose stop
```
</td>
<td>

**Возобновление:**
```shell
docker compose start
```
или
```shell
docker compose up -d
```
</td>
</tr>
</table>

---

## 🗑️ 6. Удалить установленный контейнер с PostgreSQL

### 📂 Переходим в папку проекта

```shell
cd ~/Docker/postgres-docker-project
```

### 🧹 Останавливаем и удаляем контейнеры + сети

<table>
<tr>
<td width="50%">

**Без удаления данных:**

```shell
docker compose down
```

</td>
<td width="50%">

**С удалением томов (БД!):**

```shell
docker compose down -v
```

> ⚠️ **ВСЕ ДАННЫЕ БУДУТ ПОТЕРЯНЫ!**

</td>
</tr>
</table>

> 📌 **Запомните:**
> - 🔴 Ключ `-v` удаляет БД (все данные теряются!)
> - 🟢 При удалении контейнера **образ сохраняется** и может переиспользоваться

### 🔎 Проверяем, что всё удалено

```shell
docker ps -a          # ❌ Не должно быть my-postgres
docker volume ls      # ❌ Не должно быть postgres volumes
docker network ls     # ❌ Не должно быть сетей проекта
docker images         # ✅ Образ postgres — оставляем, пригодится!
```

> 💡 Если `docker network ls` всё ещё показывает сеть вашего compose — просто выполните `docker compose down` ещё раз.

### 🧭 Что делать дальше?

<table>
<tr>
<td width="50%">

#### 🅰️ Вариант 1: Всё оставить как есть

```shell
docker compose up -d
```

Проект запустится с той же конфигурацией.

</td>
<td width="50%">

#### 🅱️ Вариант 2: Создать новый проект

```shell
mkdir new-postgres-project
cd new-postgres-project
```

Создать новый `docker-compose.yml` с учётом полученного опыта 🎓

</td>
</tr>
</table>

---

## 🎨 7. Удаление образов (опционально)

### 📋 Смотрим все образы

```shell
docker images
```

### 🔎 Проверяем, какие контейнеры используются

```shell
docker ps -a
```

> ⚠️ **Порядок важен:** сначала удаляем контейнеры (по `id`), **и только потом** образы!

### 🗑️ Удаляем образ PostgreSQL

```shell
docker rmi postgres:15
```

### 🧽 Или удаляем все неиспользуемые образы

```shell
docker image prune -a
```

### ✅ Проверяем результат

```shell
docker images
```

---

<div align="center">

### 🎉 Поздравляем! Теперь можно запустить проект с «чистого листа»!

```shell
docker compose up -d
```

---

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

**Сделано с 🐘 и ❤️ для удобной работы с Docker Compose**

</div>
