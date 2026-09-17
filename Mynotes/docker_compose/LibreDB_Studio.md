<div align="center">

# 🧑‍💻 LibreDB Studio

### *Веб-IDE для работы с базами данных прямо в браузере*

[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![LibreDB](https://img.shields.io/badge/LibreDB-Studio-7C3AED?style=for-the-badge&logo=databricks&logoColor=white)](https://github.com/libredb/libredb-studio)
[![Web IDE](https://img.shields.io/badge/Web-IDE-0EA5E9?style=for-the-badge&logo=googlechrome&logoColor=white)](http://localhost:3000)

</div>

---

<div align="center">

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🗄️  БАЗА ДАННЫХ   ◄────   🧑‍💻  LIBREDB STUDIO   ◄────   🌐 WEB  ║
║                                                              ║
║   На сервере         ◄────   Контейнер в Docker     ◄────   Браузер ║
║                                                              ║
║   ─── Никаких десктопных приложений. Всё в браузере! ───     ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

</div>

---

## 🎴 О проекте

<table>
<tr>
<td width="60%" valign="top">

### 🧑‍💻 Что такое LibreDB Studio?

**LibreDB Studio** — это открытая (MIT-лицензия) **веб-IDE** для работы с базами данных, которая разворачивается как контейнер Docker **рядом с самой базой**, а не на машине разработчика.

По сути, это **«браузерный DataGrip / DBeaver»** — единая точка входа для запросов, визуализации и администрирования.

</td>
<td width="40%" valign="top">

### 💡 Зачем это нужно?

- 🌐 **Развернул один раз** — работает для всей команды
- 📱 **Доступ с любого устройства** — включая мобильные
- 🚀 **Быстро** — не нужно ставить десктопные приложения
- 🔥 **Идеально для горящих запросов**

</td>
</tr>
</table>

> 💬 *Вместо того чтобы каждый разработчик устанавливал десктопное приложение и искал строки подключения, вы разворачиваете один контейнер на сервере (или в облаке) рядом с базой. Пользователи заходят через браузер — включая мобильные устройства, что актуально для «горящих» запросов.*

---

## 🚦 Пре-флайт проверка

> 🛑 **СТОП!** Перед запуском убедитесь, что **свободен порт `3000`**.

```shell
docker compose ls
```

> 💡 **Совет:** Остановите лишние контейнеры — меньше конфликтов за порты.

---

## 🗺️ Карта путешествия

<div align="center">

|  | Шаг | Действие | Время |
|:-:|:---:|:---|:---:|
| 🏗️ | **1** | [Создать каталог проекта](#-шаг-1-создание-каталога-проекта) | ~10 сек |
| ⚙️ | **2** | [Написать `compose.yaml`](#-шаг-2-содержимое-файла-конфигурации-composeyaml) | ~1 мин |
| 🔐 | **3** | [Создать `.env`](#-шаг-3-создайте-файл-env) | ~30 сек |
| 🚀 | **4** | [Запустить проект](#-шаг-4-установка-и-запуск-проекта) | ~2 мин |
| 🎨 | **5** | [Войти в веб-IDE](#-шаг-5-доступ-к-веб-интерфейсу) | ~30 сек |
| 🗑️ | **6** | [Удалить проект](#-шаг-6-удалить-проект) | ~30 сек |

</div>

---

## 📂 Шаг 1. Создание каталога проекта

### 🗂️ Структура

```
📦 libredb-studio/
├── 📄 compose.yaml
└── 🔐 .env
```

### ⚡ Одной командой

```shell
mkdir -p libredb-studio && touch libredb-studio/compose.yaml && cd libredb-studio
```

---

## ⚙️ Шаг 2. Содержимое файла конфигурации `compose.yaml`

> 📌 Можно также назвать `docker-compose.yml` — для совместимости со старыми версиями Docker Compose.

```yaml
services:

  # ══════════════════════════════════════════════
  #  🧑‍💻 СЕРВИС LIBREDB STUDIO
  # ══════════════════════════════════════════════
  libredb-studio:
    image: ghcr.io/libredb/libredb-studio:latest   # 📦 Официальный образ из GHCR
    container_name: libredb-studio                 # 🏷️ Имя контейнера
    ports:
      - "3000:3000"                                # 🔌 Проброс порта

    environment:
      ADMIN_EMAIL: ${ADMIN_EMAIL:-admin@libredb.org}                       # 📧 Email админа
      ADMIN_PASSWORD: ${ADMIN_PASSWORD:?set ADMIN_PASSWORD in .env}        # 🔑 Пароль (обяз.)
      JWT_SECRET: ${JWT_SECRET:?set JWT_SECRET in .env (min 32 chars)}     # 🎫 JWT-секрет
      STORAGE_PROVIDER: sqlite                                             # 💾 Тип хранилища
      STORAGE_SQLITE_PATH: /app/data/libredb-storage.db                    # 📁 Путь к БД

    volumes:
      - libredb-data:/app/data                     # 💾 Постоянное хранилище

    restart: unless-stopped                        # 🔄 Автоперезапуск

    healthcheck:                                   # ❤️ Проверка живости
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000"]
      interval: 30s                                # ⏱️ Каждые 30 секунд
      timeout: 10s                                 # ⌛ Таймаут 10 сек
      retries: 3                                   # 🔁 3 попытки
      start_period: 40s                            # 🕐 Задержка при старте

volumes:
  libredb-data:                                    # 💾 Именованный том
```

---

## 🔐 Шаг 3. Создайте файл `.env`

> 🎯 В этом файле хранятся **секреты**, которые **не должны попадать в Git**. Обязательно добавьте `.env` в `.gitignore`!

```shell
cat > .env << 'EOF'
# ══════════════════════════════════════════════
#  🔑 ОБЯЗАТЕЛЬНЫЕ ПЕРЕМЕННЫЕ
# ══════════════════════════════════════════════
ADMIN_EMAIL=admin@libredb.org
ADMIN_PASSWORD=YourStrongPassword123!
JWT_SECRET=jirweH6r53yxlN0Ei/IjO4a6lYdi+k9iFrkdzD9BPrk=

# ══════════════════════════════════════════════
#  👤 ОПЦИОНАЛЬНО: обычный пользователь
# ══════════════════════════════════════════════
USER_EMAIL=user@libredb.org
USER_PASSWORD=UserPassword123!
EOF
```

> 🔒 **Важно!** Пароль `YourStrongPassword123!` — **пример**. Замените на свой надёжный пароль.
>
> 🎫 `JWT_SECRET` — сгенерируйте случайную строку длиной **минимум 32 символа**.

---

## 🚀 Шаг 4. Установка и запуск проекта

> 📁 Находясь в каталоге проекта `libredb-studio`

### 🔍 1. Убеждаемся, что порт `3000` свободен

```shell
ss -tulpn | grep :3000
```

### 🔍 2. Проверяем, что контейнера с таким именем не существует

```shell
docker ps -a | grep libredb-studio
```

### ▶️ 3. Запускаем все сервисы проекта

```shell
docker compose up -d
```

### ✅ 4. Проверяем статус

```shell
docker compose ls
```

```shell
docker compose ps -a
```

### 📜 5. Смотрим первые 20 строк логов

```shell
docker compose logs --tail=20 libredb-studio
```

### 🔄 6. Просмотр логов в реальном времени

```shell
docker compose logs -f
```

> 🛑 Чтобы выйти из режима ожидания новых логов, нажмите `Ctrl+C`.

### 📋 7. Просмотреть все логи

```shell
docker compose logs
```

---

## 🎨 Шаг 5. Доступ к веб-интерфейсу

<div align="center">

### 🌐 [Открыть LibreDB Studio → http://localhost:3000](http://localhost:3000)

</div>

### 🔑 Данные для входа

<table align="center">
<tr>
<th>Поле</th>
<th>Значение</th>
</tr>
<tr>
<td>📧 <b>Логин (email)</b></td>
<td><code>admin@libredb.org</code></td>
</tr>
<tr>
<td>🔑 <b>Пароль</b></td>
<td><code>YourStrongPassword123!</code></td>
</tr>
</table>

> ⚠️ **Не забудьте изменить пароль** после первого входа в продакшене!

---

## 🗑️ Шаг 6. Удалить проект

### 1️⃣ Остановить и удалить контейнер + том данных

```shell
docker compose down -v
```

### 2️⃣ Удалить образ

```shell
docker image rm ghcr.io/libredb/libredb-studio:latest
```

### 3️⃣ Проверить, что ничего не осталось

```shell
docker ps -a | grep libredb-studio
```

и

```shell
docker volume ls | grep libredb
```

### 💣 4. (Опционально) Полная очистка Docker

> ⚠️ **ОСТОРОЖНО!** Удалит **всё неиспользуемое** в Docker — контейнеры, образы, тома, сети.

```shell
docker system prune -a --volumes
```

### 🧹 5. Удалить папку проекта

```shell
cd .. ; rm -rf libredb-studio
```

---

## 🔗 Полезные ссылки

| 📚 Ресурс | 🔗 Ссылка |
|:---|:---|
| 📰 **Анонс новой версии** | [opennet.ru — LibreDB Studio](https://www.opennet.ru/opennews/art.shtml?num=66216) |
| 🐙 **GitHub-репозиторий** | [github.com/libredb/libredb-studio](https://github.com/libredb/libredb-studio) |
| 🐳 **Docker-образ** | [ghcr.io/libredb/libredb-studio](https://ghcr.io/libredb/libredb-studio) |

---

<div align="center">

## 🎉 Готово!

Теперь вы умеете:

🏗️ &nbsp; Создавать **структуру проекта**<br>
⚙️ &nbsp; Писать **`compose.yaml`** с env-переменными<br>
🔐 &nbsp; Хранить **секреты в `.env`**<br>
🚀 &nbsp; Запускать **веб-IDE в Docker**<br>
🎨 &nbsp; Работать с БД **через браузер**<br>
🗑️ &nbsp; Чисто удалять проект и образы

---

### ⭐ Если проект был полезен — поставьте звезду репозиторию!

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

**Сделано с 🧑‍💻 и ❤️ для удобной работы с базами данных**

</div>
