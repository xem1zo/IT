<div align="center">

# 🐳 Docker Compose — полное руководство

**Инструмент для определения и запуска многоконтейнерных приложений**

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![YAML](https://img.shields.io/badge/Config-YAML-CB171E?style=for-the-badge&logo=yaml&logoColor=white)](https://yaml.org/)

</div>

---

> 💡 **Важно знать:**
> В современных дистрибутивах не обязательно называть файл `docker-compose.yaml` — достаточно обозвать его `compose.yaml`, и всё будет работать. Но при условии, если у тебя не допотопная ОС со старой версией Docker.
>
> Современный **Docker** давно перешёл на `compose.yaml`.

| Команда | Что это |
|---|---|
| `docker-compose` | Отдельный Python-инструмент |
| `docker compose` | Встроенный плагин Docker CLI |

> Теперь **Docker** в приоритете ищет файл `compose.yaml` и только потом старый `docker-compose.yaml`. И так, и так всё будет работать.

---

## 🏗️ Что такое Docker Compose?

**Docker Compose** — это инструмент для управления **несколькими контейнерами** как единым приложением с помощью одного файла конфигурации.

### 🎭 Простая аналогия:

| Инструмент | Что делает |
|---|---|
| 🔨 **`docker run`** | Ручная сборка одного стула по инструкции |
| 🪄 **`docker compose`** | Кнопка «собери всю мебель в комнате» по общему плану |

---

## 🎯 Зачем нужен Docker Compose?

### ❌ Проблема без Compose:

```bash
# Чтобы запустить приложение + БД + кэш, нужно:
docker run -d --name db -e POSTGRES_PASSWORD=pass postgres
docker run -d --name cache -p 6379:6379 redis
docker run -d --name app -p 80:5000 --link db --link cache my-app

# Создаются и запускаются по отдельности несколько контейнеров
# для всего лишь одного приложения. И это ещё простой случай!
```

### ✅ Решение с Compose:

```yaml
# docker-compose.yml
services:
  app:
    build: .
    ports:
      - "80:5000"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: pass
  cache:
    image: redis
```

**Запуск одной командой:**
```shell
docker compose up -d
```

---

## 📁 Структура `compose.yml` (или `docker-compose.yml`)

### Базовый пример:

```yaml
version: '3.8'  # Современные версии могут не требовать эту строку

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html

  database:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

---

## 🔧 Ключевые директивы Docker Compose

| Директива | Назначение | Пример |
|---|---|---|
| **`image`** | Готовый образ | `nginx:alpine` |
| **`build`** | Собрать из Dockerfile | `build: .` |
| **`ports`** | Проброс портов | `"8080:80"` |
| **`volumes`** | Монтирование данных | `./data:/app/data` |
| **`environment`** | Переменные окружения | `POSTGRES_PASSWORD: pass` |
| **`depends_on`** | Зависимости | `depends_on: - db` |
| **`networks`** | Сети | `networks: - app-net` |

---

## 🚀 Основные команды

### 📦 Запуск и управление

<details open>
<summary><b>Показать все Docker Compose проекты</b></summary>

```shell
docker compose ls
```
или
```shell
docker compose ls -a
```
</details>

<details open>
<summary><b>Запуск всех сервисов в фоне</b></summary>

```shell
docker compose up -d
```
> ⚠️ *В некоторых старых версиях может не сработать — обновите Docker.*
</details>

<details open>
<summary><b>Остановка всех сервисов</b></summary>

```shell
docker compose down
```
</details>

<details open>
<summary><b>Просмотр логов</b></summary>

```shell
docker compose logs
```
</details>

<details open>
<summary><b>Перезапуск сервисов</b></summary>

```shell
docker compose restart
```
</details>

<details open>
<summary><b>Выполнение команды в сервисе</b></summary>

```shell
docker compose exec db psql -U user myapp
```
</details>

---

### 🛠️ Разработка и отладка

<details open>
<summary><b>Просмотр конфигурации</b></summary>

```shell
docker compose config
```
</details>

<details open>
<summary><b>Сборка образов</b></summary>

```shell
docker compose build
```
</details>

<details open>
<summary><b>Запуск одного сервиса</b></summary>

```shell
docker compose up web
```
</details>

<details open>
<summary><b>Просмотр логов в реальном времени</b></summary>

```shell
docker compose logs -f web
```
</details>

---

## 📊 Практические примеры

### 🌐 Пример 1: Веб-приложение + БД

```yaml
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      DATABASE_URL: postgresql://user:pass@db:5432/myapp
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

---

### 📝 Пример 2: Простой блог на WordPress

```yaml
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: "1"
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
```

---

## 🎯 Преимущества Docker Compose

### 1️⃣ Однокомандное развёртывание

```bash
# Вместо 5+ команд docker run — одна команда:
docker compose up -d
```

### 2️⃣ Воспроизводимость

- ✅ Идентичное окружение у всех разработчиков
- ✅ Файл `compose.yml` в системе контроля версий

### 3️⃣ Управление зависимостями

- ✅ Автоматический порядок запуска сервисов
- ✅ Сетевые соединения между контейнерами

### 4️⃣ Изоляция проектов

- ✅ Каждый проект в своей папке
- ✅ Нет конфликтов между проектами

---

## 🔧 Продвинутые возможности

### 🌱 Переменные окружения

```yaml
services:
  app:
    image: myapp:${APP_VERSION:-latest}
    environment:
      - DATABASE_URL=${DATABASE_URL}
    env_file:
      - .env
```

### ⚙️ Настройки развёртывания

```yaml
services:
  web:
    image: nginx
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
    restart_policy:
      condition: on-failure
```

### ❤️ Health checks

```yaml
services:
  db:
    image: postgres
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d myapp"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

## 📁 Структура проекта с Docker Compose

```
my-app/
├── docker-compose.yml
├── .env
├── backend/
│   ├── Dockerfile
│   └── src/
├── frontend/
│   ├── Dockerfile
│   └── src/
└── database/
    └── init.sql
```

---

## 💡 Best Practices

### 1. Используйте `.env` файлы

```bash
# .env
POSTGRES_PASSWORD=secure_password
APP_VERSION=1.2.3
```

### 2. Разделяйте конфигурации

```yaml
# docker-compose.yml          — базовая конфигурация
# docker-compose.override.yml — для разработки
# docker-compose.prod.yml     — для продакшена
```

### 3. Используйте именованные volumes

```yaml
volumes:
  db_data:
    driver: local
```

### 4. Настраивайте health checks

```yaml
healthcheck:
  test: curl -f http://localhost/health || exit 1
  interval: 30s
```

---

## 🚀 Workflow разработки

### 💻 Локальная разработка

```bash
# Клонируем проект
git clone project-url
cd project

# Запускаем окружение
docker compose up -d

# Работаем...
code .

# Останавливаем
docker compose down
```

### 🏭 Продакшен

```bash
# Используем продакшен конфигурацию
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## 🔄 Docker Compose vs Docker Swarm vs Kubernetes

| Инструмент | Сценарии использования | Сложность |
|---|---|---|
| 🐳 **Docker Compose** | Локальная разработка, тестирование | 🟢 Низкая |
| 🐝 **Docker Swarm** | Простые кластеры, small-scale production | 🟡 Средняя |
| ☸️ **Kubernetes** | Сложные production-среды, масштабирование | 🔴 Высокая |

---

## 💡 Советы для начинающих

1. 🌱 **Начинайте с простых конфигураций**
2. 🔍 **Используйте `docker compose config` для проверки**
3. 📜 **Изучайте логи при проблемах**
4. 🧪 **Экспериментируйте с разными сервисами**
5. 📦 **Используйте официальные образы**

---

## 🎯 Итог

**Docker Compose идеален для:**

| Сценарий | Описание |
|---|---|
| 🏗️ **Локальной разработки** | Быстрый запуск окружения |
| 🧪 **Тестирования** | Многоконтейнерные приложения |
| 🚀 **Прототипирования** | Быстрая проверка идей |
| 📚 **Изучения Docker** | Понимание микросервисов |

---

<div align="center">

**Теперь у вас есть мощный инструмент для управления сложными приложениями!** 🐳✨

---

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

</div>
