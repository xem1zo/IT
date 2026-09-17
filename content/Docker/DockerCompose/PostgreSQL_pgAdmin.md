<div align="center">

# 🐘 PostgreSQL + pgAdmin

### *Полноценный стек для работы с базами данных в Docker*

<br>

<img src="https://img.shields.io/badge/PostgreSQL-17-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
&nbsp;&nbsp;➕&nbsp;&nbsp;
<img src="https://img.shields.io/badge/pgAdmin-4-326690?style=for-the-badge&logo=pgadmin&logoColor=white" alt="pgAdmin"/>
&nbsp;&nbsp;➕&nbsp;&nbsp;
<img src="https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/>

<br><br>

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17--alpine-336791?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![pgAdmin](https://img.shields.io/badge/pgAdmin-4-326690?style=flat-square&logo=pgadmin&logoColor=white)](https://www.pgadmin.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![YAML](https://img.shields.io/badge/Config-YAML-CB171E?style=flat-square&logo=yaml&logoColor=white)](https://yaml.org/)

</div>
---

<div align="center">

```
╔══════════════════════════════════════════════════════════════╗
║   🐘 POSTGRES  ────►  🎛️ PGADMIN  ────►  💻 BROWSER         ║
║                                                              ║
║   Хранилище    ────►  Управление  ────►  Визуализация       ║
╚══════════════════════════════════════════════════════════════╝
```

</div>

---

## 🎴 О проекте

<table>
<tr>
<td width="50%" valign="top">

### 🐘 PostgreSQL
**Объектно-реляционная СУБД** с открытым исходным кодом.

- 🏆 Одна из самых надёжных СУБД в мире
- 🔓 Полностью бесплатная
- 🌍 Поддержка сообщества по всему миру

</td>
<td width="50%" valign="top">

### 🎛️ pgAdmin 4
**Официальный графический клиент** для PostgreSQL.

- 🖥️ Веб-интерфейс
- 📊 Визуальные инструменты
- 🔍 Удобный SQL-редактор

</td>
</tr>
</table>

---

## 🚦 Пре-флайт проверка

> 🛑 **ОСТАНОВИТЕСЬ!** Перед запуском убедитесь, что **свободны порты** `5432` и `5050`.

```shell
docker compose ls
```

> 💡 **Лайфхак:** остановите лишние контейнеры — меньше конфликтов, больше счастья.

---

## 🗺️ Карта путешествия

<div align="center">

|  | Шаг | Действие | Время |
|:-:|:---:|:---|:---:|
| 🏗️ | **1** | [Создать каталог проекта](#-шаг-1-создание-каталога-проекта) | ~10 сек |
| ⚙️ | **2** | [Написать `compose.yaml`](#-шаг-2-содержимое-файла-конфигурации-composeyaml) | ~2 мин |
| 🚀 | **3** | [Запустить контейнеры](#-шаг-3-установка-и-запуск-проекта) | ~1 мин |
| 🌐 | **4** | [Войти в pgAdmin](#-шаг-4-доступ-к-pgadmin) | ~30 сек |
| 🔌 | **5** | [Подключиться к PostgreSQL](#-шаг-5-подключение-pgadmin-к-postgresql) | ~1 мин |
| 🛠️ | **6** | [Управление](#-шаг-6-управление-и-полезные-команды) | — |
| 🗑️ | **7** | [Удаление](#-шаг-7-удаление-этого-проекта) | ~30 сек |

</div>

---

## 📁 Шаг 1. Создание каталога проекта

### 🗂️ Структура

```
📦 postgres-pgadmin-app/
└── 📄 compose.yaml
```

### ⚡ Одной командой

```shell
mkdir -p postgres-pgadmin-app && cd postgres-pgadmin-app && touch compose.yaml
```

> 🎯 Всё готово! Теперь заполним конфиг.

---

## ⚙️ Шаг 2. Содержимое файла конфигурации `compose.yaml`

> 📌 Можно также назвать `docker-compose.yml` — для совместимости со старыми версиями Docker Compose.

```yaml
services:

  # ══════════════════════════════════════════════
  #  🐘 СЕРВИС POSTGRESQL
  # ══════════════════════════════════════════════
  postgres:
    image: postgres:17-alpine          # 📦 Лёгкий alpine-образ PostgreSQL 17
    container_name: postgres-db        # 🏷️ Имя контейнера
    environment:
      POSTGRES_USER: myuser            # 👤 Имя пользователя
      POSTGRES_PASSWORD: mypassword    # 🔑 Пароль
      POSTGRES_DB: mydatabase          # 🗄️ Имя БД
    ports:
      - "5432:5432"                    # 🔌 Проброс порта
    volumes:
      - postgres_data:/var/lib/postgresql/data  # 💾 Данные

  # ══════════════════════════════════════════════
  #  🎛️ СЕРВИС PGADMIN 4
  # ══════════════════════════════════════════════
  pgadmin:
    image: dpage/pgadmin4:latest       # 📦 Официальный образ pgAdmin
    container_name: pgadmin-web        # 🏷️ Имя контейнера
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com     # 📧 Логин
      PGADMIN_DEFAULT_PASSWORD: admin              # 🔑 Пароль
    ports:
      - "5050:80"                      # 🔌 Проброс порта

volumes:
  postgres_data:                       # 💾 Именованный том
```

> 💡 **Обратите внимание:** pgAdmin **не имеет** секции `volumes` — его настройки не так критичны, и при перезапуске он попросит заново подключиться к БД.

---

## 🚀 Шаг 3. Установка и запуск проекта

### ▶️ Поднимаем оба контейнера

```shell
docker compose up -d
```

### 🔍 Проверяем статус

```shell
docker compose ps -a
```

### 📊 Ожидаемый результат

<div align="center">

| 🏷️ Name | 🖼️ Image | 📌 Status | 🔌 Ports |
|:---|:---|:---:|:---|
| `postgres-db` | `postgres:17-alpine` | 🟢 **Up** | `0.0.0.0:5432→5432/tcp` |
| `pgadmin-web` | `dpage/pgadmin4:latest` | 🟢 **Up** | `0.0.0.0:5050→80/tcp` |

</div>

> ✅ Оба контейнера должны иметь статус **`Up`**.

---

## 🌐 Шаг 4. Доступ к pgAdmin

<div align="center">

### 🔓 [**http://localhost:5050**](http://localhost:5050)

</div>

### 🔑 Данные для входа

<table align="center">
<tr>
<th>Поле</th>
<th>Значение</th>
</tr>
<tr>
<td>📧 <b>Email / Username</b></td>
<td><code>admin@example.com</code></td>
</tr>
<tr>
<td>🔑 <b>Password</b></td>
<td><code>admin</code></td>
</tr>
</table>

---

## 🔌 Шаг 5. Подключение pgAdmin к PostgreSQL

### 📝 Шаг за шагом

<details open>
<summary><b>1️⃣ Вкладка <code>General</code> — общее</b></summary>

> 💬 Задайте любое понятное имя для сервера, например:
> ```
> My Local PostgreSQL
> ```

</details>

<details open>
<summary><b>2️⃣ Вкладка <code>Connection</code> — параметры подключения</b></summary>

| 🔧 Поле | 📌 Значение | 💡 Что это |
|:---|:---|:---|
| **Host name/address** | `postgres-db` | Имя сервиса PostgreSQL из `compose.yaml` |
| **Port** | `5432` | Порт PostgreSQL |
| **Maintenance database** | `mydatabase` | Служебная БД |
| **Username** | `myuser` | Пользователь из env |
| **Password** | `mypassword` | Пароль из env |

</details>

<details open>
<summary><b>3️⃣ Сохраняем — кнопка <code>Save</code></b></summary>

> 💾 После нажатия **Save** pgAdmin установит соединение и покажет дерево объектов БД.

</details>

### 📸 Скриншоты

<div align="center">

![Screen 1](/content/Docker/DockerCompose/img/16.png)
![Screen 2](/content/Docker/DockerCompose/img/17.png)
![Screen 3](/content/Docker/DockerCompose/img/18.png)
![Screen 4](/content/Docker/DockerCompose/img/19.png)

</div>

---

## 🛠️ Шаг 6. Управление и полезные команды

> 📁 Все команды выполняются из папки `postgres-pgadmin-app`

<details open>
<summary><b>📜 1. Логи pgAdmin в реальном времени</b></summary>

```shell
docker compose logs -f pgadmin
```

> `-f` — режим follow (поток в реальном времени).
> 🛑 Выход: `Ctrl+C`.

</details>

<details open>
<summary><b>📜 2. Логи PostgreSQL в реальном времени</b></summary>

```shell
docker compose logs -f postgres
```

> 🛑 Выход: `Ctrl+C`.

</details>

<details open>
<summary><b>⏸️ 3. Приостановить запущенный контейнер</b></summary>

```shell
docker compose stop
```

</details>

<details open>
<summary><b>▶️ 4. Запустить приостановленный контейнер</b></summary>

```shell
docker compose start
```

</details>

<details open>
<summary><b>🔄 5. Перезапустить</b></summary>

```shell
docker compose restart
```

</details>

<details open>
<summary><b>⚙️ 6. Показать конфигурацию текущего проекта</b></summary>

```shell
docker compose config
```

</details>

<details open>
<summary><b>🐚 7. Вход в контейнер PostgreSQL</b></summary>

> ℹ️ Имя контейнера можно узнать командой `docker compose ps`.

```shell
docker compose exec postgres bash
```

> 🚪 Выход: `exit`.

</details>

### 📸 Скриншот

<div align="center">

![Screen 5](/content/Docker/DockerCompose/img/20.png)

</div>

---

## 🗑️ Шаг 7. Удаление этого проекта

> 📁 Работаем из папки `postgres-pgadmin-app`

### 🎯 Вариант A — Мягкое удаление (с сохранением данных)

```shell
docker compose down
```

> ✅ Контейнеры удалены, **том `postgres_data` сохранён**.

### 💣 Вариант B — Жёсткое удаление (полная очистка)

```shell
docker compose down --volumes
```

или короче:

```shell
docker compose down -v
```

> ⚠️ **ВНИМАНИЕ!** Эта команда **удалит все данные БД** без возможности восстановления!

---

### 🧭 Итоговый маршрут удаления

<div align="center">

```
   ┌──────────────────┐
   │  🛑 down -v      │  ← Остановить + удалить контейнеры + тома
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │  🗑️ docker rmi   │  ← (опционально) удалить образы
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │  🚪 cd ..        │  ← Выйти из папки проекта
   └────────┬─────────┘
            ▼
   ┌──────────────────┐
   │  🧹 rm -rf ...   │  ← Удалить каталог проекта
   └──────────────────┘
```

</div>

### 📋 Команды

```shell
# 1. Выходим из каталога проекта
cd ..

# 2. Удаляем папку проекта
rm -rf postgres-pgadmin-app
```

---

<div align="center">

## 🎉 Готово!

Теперь вы умеете:

🐘 &nbsp; Поднимать **PostgreSQL** в Docker<br>
🎛️ &nbsp; Подключать **pgAdmin** через веб-интерфейс<br>
🔌 &nbsp; Управлять БД и контейнерами<br>
🗑️ &nbsp; Чисто удалять проекты за собой

---

### ⭐ Если проект был полезен — поставьте звезду репозиторию!

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

**Сделано с ❤️ для удобной работы с Docker Compose**

</div>
