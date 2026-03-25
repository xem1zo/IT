# 🐳 DockerInfo — Заметки о Docker

> 📋 Проект для хранения всех заметок, руководств и справочной информации по Docker

---

## 📚 Оглавление

1. [Что такое Docker?](#-что-такое-docker)
2. [История появления и развития](#-история-появления-и-развития)
3. [Современное состояние (2026)](#-современное-состояние-2026)
4. [Docker Hub и готовые образы](#-docker-hub-и-готовые-образы)
5. [Dockerfile](#-dockerfile)
6. [Docker Compose](#-docker-compose)
7. [Полезные команды](#-полезные-команды)
8. [Ресурсы](#-ресурсы)

---

## 🔹 Что такое Docker?

**Docker** — это платформа с открытым исходным кодом для разработки, доставки и запуска приложений в изолированных средах, называемых **контейнерами**.

### Ключевые концепции:

| Термин | Описание |
|--------|----------|
| **Контейнер** | Лёгкая, изолированная среда выполнения приложения со всеми зависимостями |
| **Образ (Image)** | Шаблон только для чтения, используемый для создания контейнеров |
| **Dockerfile** | Текстовый файл с инструкциями для сборки образа |
| **Docker Hub** | Облачный реестр для хранения и распространения образов |
| **Docker Compose** | Инструмент для определения и запуска многоконтейнерных приложений |

### Преимущества Docker:
```
✅ Портативность: "работает на моей машине" → работает везде
✅ Изоляция: приложения не конфликтуют между собой
✅ Эффективность: контейнеры легче виртуальных машин
✅ Масштабируемость: легко запускать множество экземпляров
✅ Воспроизводимость: одинаковая среда на всех этапах жизненного цикла
```

> 🎯 **Философия Docker**: *Build, Ship, and Run Any App, Anywhere* [[1]]

---

## 🔹 История появления и развития

### 🗓️ Хронология ключевых событий:

```
🔹 2008 — Создана компания DotCloud (основатели: Solomon Hykes, Kamel Founadi, Sebastien Pahl) [[2]]

🔹 2010 — DotCloud получает поддержку от Y Combinator и начинает привлекать инвестиции

🔹 2013, март — Публичный релиз Docker на конференции PyCon 2013 [[3]][[9]]
   • Первая версия: Docker 0.1
   • Изначально назывался "dotCloud", переименован в сентябре 2013

🔹 2014, июнь — Выпуск Docker 1.0 (первая стабильная версия)

🔹 2014 — Запуск Docker Hub (облачный реестр образов)

🔹 2015 — Создание Open Container Initiative (OCI) для стандартизации контейнеров

🔹 2016 — Выпуск Docker Compose file format 2.x [[8]]

🔹 2017 — Docker Compose file format 3.x с поддержкой Swarm mode

🔹 2019 — Разделение Docker Engine на Moby (open-source) и Docker CE/EE

🔹 2020 — Анонс Docker Compose v2 (переписан на Go, команда: `docker compose`) [[8]]

🔹 2024 — 11-летний юбилей Docker: 26 млн активных пользователей, 15 млн репозиториев на Docker Hub [[9]]

🔹 2025 — Выпуск Docker Compose v5 с официальным Go SDK [[8]]

🔹 2026 — Активное развитие: Docker Scout, Build Cloud, Hardened Images, интеграция с GenAI [[9]]
```

### Эволюция архитектуры:
```
DotCloud (PaaS) 
    ↓
Docker как внутренний инструмент контейнеризации
    ↓
Открытый исходный код → массовое принятие сообществом
    ↓
Стандартизация через OCI → экосистема Kubernetes, containerd
    ↓
Современная платформа для полной цепочки разработки
```

---

## 🔹 Современное состояние (2026)

### 📊 Статистика и экосистема [[9]]:
- **17+ млн** зарегистрированных разработчиков
- **26 млн** ежемесячных активных IP-адресов
- **15 млн** репозиториев на Docker Hub
- **25 млрд** скачиваний образов в месяц
- **79 000+** корпоративных клиентов
- **#1** самый востребованный инструмент по версии Stack Overflow (4 года подряд)

### 🔧 Ключевые продукты Docker сегодня:

| Продукт | Назначение |
|---------|-----------|
| **Docker Desktop** | Локальная среда разработки для Windows, macOS, Linux |
| **Docker Hub** | Облачный реестр образов с публичными и приватными репозиториями |
| **Docker Scout** | Анализ уязвимостей и безопасности образов |
| **Docker Build Cloud** | Ускорение сборки образов в облаке |
| **Docker Hardened Images** | Безопасные образы с минимальным количеством CVE |
| **GenAI Stack** | Готовый стек для разработки приложений с ИИ (Ollama + LangChain + Neo4j) |

### 🔄 Современные тренды:
```
🔹 Shift-left security — проверка безопасности на этапе разработки
🔹 Software Supply Chain — управление цепочкой поставок ПО
🔹 WebAssembly (Wasm) — поддержка альтернативных сред выполнения
🔹 Dev Team Productivity — инструменты для ускорения "inner loop" разработки
🔹 AI-assisted development — интеграция с генеративным ИИ
```

---

## 🔹 Docker Hub и готовые образы

### 🌐 Что такое Docker Hub?

**Docker Hub** — крупнейший в мире реестр контейнерных образов, предоставляющий:
- Хранение и управление образами
- Автоматическую сборку из репозиториев GitHub/Bitbucket
- Webhooks для автоматизации рабочих процессов
- Управление доступом для команд и организаций [[11]]

### 📦 Типы образов на Docker Hub:

```
🔹 Docker Official Images (DOI)
   • Курируемые образы с документацией и лучшими практиками
   • Регулярно обновляются, проходят проверку безопасности
   • Примеры: `nginx`, `postgres`, `python`, `node`

🔹 Verified Publisher Images
   • Образы от официальных партнёров Docker
   • Подтверждённая подлинность и поддержка

🔹 Docker-Sponsored Open Source
   • Образы от open-source проектов при поддержке Docker

🔹 Community Images
   • Образы, созданные сообществом (требуют дополнительной проверки)
```

### 🚀 Работа с образами: базовые команды

```bash
# Поиск образа
docker search nginx

# Скачивание образа
docker pull nginx:latest
docker pull python:3.11-slim  # конкретная версия

# Просмотр локальных образов
docker images
docker image ls

# Удаление образа
docker rmi <image_id>

# Просмотр истории слоёв образа
docker history nginx

# Проверка образа на уязвимости (Docker Scout)
docker scout cves nginx:latest
```

### ⚠️ Best Practices при использовании образов:
```dockerfile
# ✅ Используйте конкретные теги, а не 'latest'
FROM python:3.11.4-slim

# ✅ Используйте минимальные базовые образы (Alpine, distroless)
FROM alpine:3.19@sha256:<digest>  # с фиксацией digest для воспроизводимости

# ✅ Регулярно обновляйте базовые образы
docker build --pull -t myapp:latest .

# ✅ Используйте multi-stage сборки для уменьшения размера финального образа
```

> 💡 **Совет**: Для корпоративного использования рассмотрите приватные реестры (GitLab Registry, Harbor, AWS ECR) или self-hosted Docker Registry [[15]].

---

## 🔹 Dockerfile

### 📝 Что такое Dockerfile?

**Dockerfile** — текстовый файл с инструкциями для автоматической сборки Docker-образа.

### 🔑 Основные инструкции:

| Инструкция | Описание | Пример |
|-----------|----------|--------|
| `FROM` | Базовый образ | `FROM python:3.11-slim` |
| `WORKDIR` | Рабочая директория | `WORKDIR /app` |
| `COPY` / `ADD` | Копирование файлов | `COPY requirements.txt .` |
| `RUN` | Выполнение команд при сборке | `RUN pip install -r requirements.txt` |
| `ENV` | Переменные окружения | `ENV PYTHONUNBUFFERED=1` |
| `EXPOSE` | Объявление порта | `EXPOSE 8000` |
| `CMD` / `ENTRYPOINT` | Команда запуска контейнера | `CMD ["python", "app.py"]` |
| `USER` | Переключение пользователя | `USER nobody` |
| `HEALTHCHECK` | Проверка здоровья контейнера | `HEALTHCHECK CMD curl -f http://localhost/ || exit 1` |

### 🎯 Пример production-ready Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1

# Stage 1: Build
FROM python:3.11-slim@sha256:abc123... AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim@sha256:abc123...

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .

# Set environment variables
ENV PATH=/home/appuser/.local/bin:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Start application
CMD ["python", "app.py"]
```

### 🛡️ Best Practices для Dockerfile [[21]][[22]]:

```
✅ Используйте multi-stage сборки для уменьшения размера образа
✅ Выбирайте минимальные и доверенные базовые образы
✅ Фиксируйте версии зависимостей (не используйте 'latest')
✅ Объединяйте RUN-команды через && для уменьшения слоёв
✅ Используйте .dockerignore для исключения ненужных файлов
✅ Запускайте приложения от non-root пользователя
✅ Создавайте ephemeral-контейнеры (без сохранения состояния)
✅ Сортируйте зависимости в алфавитном порядке для лучшего кэширования
✅ Используйте --no-install-recommends для apt и очищайте кэш
```

### 🧹 Файл `.dockerignore` (пример):
```gitignore
# Git
.git
.gitignore

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
.env

# IDE
.vscode/
.idea/
*.swp

# Docker
Dockerfile*
docker-compose*.yml
!.dockerignore

# Docs
*.md
docs/

# Tests
tests/
.pytest_cache/
.coverage
htmlcov/
```

---

## 🔹 Docker Compose

### 📋 Что такое Docker Compose?

**Docker Compose** — инструмент для определения и запуска многоконтейнерных приложений с помощью YAML-файла [[31]].

### 🔄 Версии Compose [[8]]:

| Версия | CLI-команда | Язык | Статус | Особенности |
|--------|------------|------|--------|-------------|
| **Compose v1** | `docker-compose` | Python | ❌ Устарела | Файлы с `version: "2.x"/"3.x"` |
| **Compose v2** | `docker compose` | Go | ✅ Поддерживается | Следует Compose Specification, игнорирует `version` |
| **Compose v5** | `docker compose` | Go | ✅ Поддерживается | + Официальный Go SDK для интеграции |

### 📄 Пример `compose.yaml` (современный синтаксис):

```yaml
# compose.yaml
name: myapp

services:
  # Веб-приложение
  web:
    build:
      context: .
      dockerfile: Dockerfile
      target: production  # для multi-stage
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    restart: unless-stopped
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # База данных
  db:
    image: postgres:15-alpine@sha256:abc123...
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    secrets:
      - db_password
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Кэш
  cache:
    image: redis:7-alpine@sha256:def456...
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - app-network

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### 🎮 Основные команды Docker Compose:

```bash
# Запуск всех сервисов
docker compose up

# Запуск в фоновом режиме
docker compose up -d

# Остановка и удаление контейнеров
docker compose down

# Остановка с удалением томов
docker compose down -v

# Просмотр логов
docker compose logs -f
docker compose logs -f web  # логи конкретного сервиса

# Выполнение команды в сервисе
docker compose exec web bash
docker compose run --rm web python manage.py migrate

# Сборка образов
docker compose build
docker compose build --no-cache  # без кэша

# Просмотр состояния
docker compose ps
docker compose top

# Масштабирование сервиса
docker compose up -d --scale web=3

# Проверка конфигурации
docker compose config
```

### 💡 Преимущества Docker Compose:
```
✅ Единый файл конфигурации для всей инфраструктуры
✅ Простое управление зависимостями между сервисами
✅ Изолированные среды для разработки, тестирования, production
✅ Легко воспроизводимая настройка для всей команды
✅ Интеграция с CI/CD пайплайнами
```

---

## 🔹 Полезные команды

### 🔍 Диагностика и мониторинг:
```bash
# Просмотр ресурсов контейнеров
docker stats

# Инспекция контейнера/образа
docker inspect <name>

# Просмотр логов
docker logs -f --tail 100 <container>

# Вход в запущенный контейнер
docker exec -it <container> /bin/bash

# Копирование файлов
docker cp file.txt container:/path/
docker cp container:/path/file.txt ./
```

### 🧹 Очистка и оптимизация:
```bash
# Удаление остановленных контейнеров
docker container prune

# Удаление неиспользуемых образов
docker image prune -a

# Полная очистка (осторожно!)
docker system prune -a --volumes

# Просмотр использования диска
docker system df
```

### 🔐 Безопасность:
```bash
# Сканирование образа на уязвимости
docker scout cves <image>

# Проверка конфигурации безопасности
docker scout quickview <image>

# Запуск в read-only режиме
docker run --read-only <image>

# Ограничение ресурсов
docker run --memory="512m" --cpus="1.5" <image>
```

---

## 🔹 Ресурсы

### 📚 Официальная документация:
- [Docker Docs](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Compose Specification](https://compose-spec.io/)
- [Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)

### 🛠️ Инструменты:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Docker Scout](https://www.docker.com/products/docker-scout/)
- [Testcontainers](https://testcontainers.com/) — для тестирования

### 📖 Обучение:
- [Docker — Getting Started](https://docs.docker.com/get-started/)
- [Play with Docker](https://labs.play-with-docker.com/) — песочница в браузере
- [Docker Curriculum](https://docker-curriculum.com/)

### 🌐 Сообщество:
- [Docker Community Forums](https://forums.docker.com/)
- [GitHub: docker/docker](https://github.com/docker/docker)
- [Stack Overflow: docker tag](https://stackoverflow.com/questions/tagged/docker)

---

## 📝 История изменений этого репозитория

| Дата | Версия | Изменения |
|------|--------|-----------|
| 2026-03-16 | 1.0.0 | ✅ Первоначальное создание: базовая структура и документация по Docker |
| | | 📝 Добавлены разделы: история, Docker Hub, Dockerfile, Compose |
| | | 🔗 Добавлены ссылки на официальные ресурсы |

---

> 🐳 **DockerInfo** — ваш персональный справочник по контейнеризации  
> 🔄 *Последнее обновление: Март 2026*  
> 👤 *Поддерживается: [Ваше имя/ник]*

---

## 🚀 Инструкция по использованию репозитория

### Создание репозитория (пошагово):

```bash
# 1. Создайте новый репозиторий на GitHub/Gitflic с именем "DockerInfo"

# 2. Клонируйте репозиторий локально
git clone https://github.com/your-username/DockerInfo.git
cd DockerInfo

# 3. Создайте структуру папок (опционально)
mkdir -p notes examples cheatsheets

# 4. Добавьте файлы
#    - README.md (этот файл)
#    - info.md (дополнительные заметки)
#    - .gitignore (шаблон для Docker-проектов)

# 5. Закоммитьте изменения
git add .
git commit -m "feat: initial commit with Docker documentation"

# 6. Отправьте на сервер
git push origin main

# 7. Отправьте ссылку преподавателю:
#    https://github.com/your-username/DockerInfo
```

### Рекомендуемые расширения VS Code:
```
🔹 Docker (от Microsoft) — подсветка, IntelliSense для Dockerfile
🔹 YAML (от Red Hat) — поддержка compose.yaml
🔹 Docker Language Support — улучшенная навигация
🔹 Docker Tools — интеграция с Docker CLI
```
