<div align="center">

# 🏠 HomeHub в Docker

### *Универсальная семейная панель управления в вашей домашней сети*

[![HomeHub](https://img.shields.io/badge/HomeHub-Family%20Dashboard-4F46E5?style=for-the-badge&logo=homeassistant&logoColor=white)](https://github.com/surajverma/homehub)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Flask](https://img.shields.io/badge/Flask-Production-000000?style=for-the-badge&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Raspberry Pi](https://img.shields.io/badge/Raspberry%20Pi-Ready-A22846?style=for-the-badge&logo=raspberrypi&logoColor=white)](https://www.raspberrypi.org/)

</div>

---

<div align="center">

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   👨‍👩‍👧‍👦  СЕМЬЯ   ────►   🏠  HOMEHUB   ────►   📱  БРАУЗЕР     ║
║                                                              ║
║   Заметки       ────►   Центральный     ────►   Любое       ║
║   Списки              узел                      устройство  ║
║   Расходы                                                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

</div>

---

## 🎴 О проекте

<table>
<tr>
<td width="60%" valign="top">

### 🏠 Что такое HomeHub?

**HomeHub** — это лёгкое веб-приложение, которое можно разместить на **собственном сервере** и которое превращает любой компьютер (даже `Raspberry Pi!`) в центральный узел для всей семьи.

Ваше приватное пространство для повседневных дел — без облаков и слежки.

</td>
<td width="40%" valign="top">

### ✨ Что умеет?

- 📝 Заметки
- 🛒 Списки покупок
- ✅ Домашние дела
- 🎬 Медиафайлы
- 💰 Расходы
- 🔗 QR-генератор
- 📄 PDF-сжатие
- ⏰ Напоминания

</td>
</tr>
</table>

> 💬 *Вам когда-нибудь хотелось иметь в домашней сети простое приватное пространство для повседневных дел всей семьи? Это — HomeHub.*

> 🔗 **GitHub-репозиторий:** [github.com/surajverma/homehub](https://github.com/surajverma/homehub)

---

## 🚦 Пре-флайт проверка

> 🛑 **СТОП!** Перед запуском убедитесь, что **свободен порт `5000`**.

> 💡 **Совет:** Остановите лишние контейнеры, чтобы избежать конфликтов.

---

## 🗺️ Карта путешествия

<div align="center">

|  | Шаг | Действие | Время |
|:-:|:---:|:---|:---:|
| 📥 | **1** | [Клонировать HomeHub](#-шаг-1-получение-homehub-из-аппстрима) | ~30 сек |
| ⚙️ | **2** | [Настроить `compose.yml`](#-шаг-2-файл-composeyml) | ~1 мин |
| 🎛️ | **3** | [Настроить `config.yml`](#-шаг-3-файл-configyml) | ~2 мин |
| 🚀 | **4** | [Запустить проект](#-шаг-4-установка-и-запуск-homehub-локально) | ~2 мин |
| 🏠 | **5** | [Открыть панель](#-шаг-5-доступ-к-homehub) | ~30 сек |
| 🗑️ | **6** | [Удалить проект](#-шаг-6-удалить-проект) | ~30 сек |

</div>

---

## 📥 Шаг 1. Получение HomeHub из аппстрима

> 🧭 **Аппстрим (appstream)** — автор-разработчик, предоставляющий единую инфраструктуру для описания своего программного обеспечения.

### 📂 Клонируем репозиторий

```shell
git clone https://github.com/surajverma/homehub.git
```

### 📁 Переходим в папку проекта и создаём `config.yml`

```shell
cd homehub && touch config.yml
```

---

## ⚙️ Шаг 2. Файл `compose.yml`

> 📌 Замените содержимое файла — он **уже есть** в клонированном репозитории.

```yaml
# ══════════════════════════════════════════════
#  🏠 HOMEHUB — Docker Compose
# ══════════════════════════════════════════════
services:
  homehub:
    container_name: homehub                             # 🏷️ Имя контейнера
    image: ghcr.io/surajverma/homehub:latest            # 📦 Официальный образ
    ports:
      - "5000:5000"                                      # 🔌 Приложение слушает 5000

    environment:
      - FLASK_ENV=production                             # 🌍 Режим продакшена
      - SECRET_KEY=${SECRET_KEY:-}                       # 🎫 Секрет (из .env или случайный)

    volumes:
      - ./uploads:/app/uploads                           # 📤 Загрузки
      - ./media:/app/media                               # 🎬 Медиафайлы
      - ./pdfs:/app/pdfs                                 # 📄 PDF-файлы
      - ./data:/app/data                                 # 💾 Данные приложения
      - ./config.yml:/app/config.yml:ro                  # 🎛️ Конфиг (только чтение)
```

> 💡 **Обратите внимание:** `config.yml` монтируется в режиме **`:ro`** (read-only) — приложение не сможет его случайно изменить.

---

## 🎛️ Шаг 3. Файл `config.yml`

> 🧩 **Как это читать:** параметры сгруппированы по блокам. Меняйте то, что нужно — остальное оставьте по умолчанию.

```yaml
# ══════════════════════════════════════════════
#  🏠 ОСНОВНЫЕ НАСТРОЙКИ
# ══════════════════════════════════════════════
instance_name: "My Home Hub"        # 🏷️ Название вашей панели
password: ""                        # 🔓 Пусто = доступ без пароля
admin_name: "Administrator"         # 👤 Имя администратора

# ══════════════════════════════════════════════
#  🎚️ ВКЛЮЧЕНИЕ МОДУЛЕЙ
# ══════════════════════════════════════════════
feature_toggles:
  shopping_list: true               # 🛒 Список покупок
  media_downloader: true            # 🎬 Загрузчик медиа
  pdf_compressor: true              # 📄 Сжатие PDF
  qr_generator: true                # 🔳 QR-генератор
  notes: true                       # 📝 Заметки
  shared_cloud: true                # ☁️ Общее облако
  who_is_home: true                 # 🏠 Кто дома
  personal_status: true             # 💬 Личный статус
  chores: true                      # ✅ Домашние дела
  recipes: true                     # 🍳 Рецепты
  expiry_tracker: true              # ⏳ Сроки годности
  url_shortener: true               # 🔗 Сокращатель ссылок
  expense_tracker: true             # 💰 Учёт расходов

# ══════════════════════════════════════════════
#  👨‍👩‍👧‍👦 ЧЛЕНЫ СЕМЬИ
# ══════════════════════════════════════════════
family_members:
  - Mom
  - Dad
  - Dipanshu
  - Vivek
  - India

# ══════════════════════════════════════════════
#  ⏰ НАПОМИНАНИЯ
# ══════════════════════════════════════════════
reminders:
  # 🕐 Формат времени: "12h" (по умолчанию) или "24h"
  time_format: 12h

  # 📅 День начала календаря: sunday, saturday, monday...
  calendar_start_day: monday

  # 🏷️ Категории напоминаний
  categories:
    - key: health                    # 🏥 Здоровье
      label: Health
      color: "#dc2626"
    - key: bills                     # 💸 Счета
      label: Bills
      color: "#0d9488"
    - key: school                    # 🎓 Школа
      label: School
      color: "#7c3aed"
    - key: family                    # 👨‍👩‍👧 Семья
      label: Family
      color: "#2563eb"

# ══════════════════════════════════════════════
#  🎨 ТЕМА ОФОРМЛЕНИЯ (опционально)
# ══════════════════════════════════════════════
theme:
  primary_color: "#1d4ed8"           # 🔵 Основной цвет
  secondary_color: "#a0aec0"         # ⚪ Дополнительный
  background_color: "#f7fafc"        # ⬜ Фон
  card_background_color: "#fff"      # 🃏 Фон карточек
  text_color: "#333"                 # ⚫ Текст
  sidebar_background_color: "#2563eb"           # 📚 Фон сайдбара
  sidebar_text_color: "#ffffff"                 # 📚 Текст сайдбара
  sidebar_link_color: "rgba(255,255,255,0.95)"  # 🔗 Ссылки
  sidebar_link_border_color: "rgba(255,255,255,0.18)"
  sidebar_active_color: "#3b82f6"               # 🎯 Активный пункт
```

---

## 🚀 Шаг 4. Установка и запуск HomeHub локально

### ▶️ Запускаем проект

```shell
docker compose up -d
```

> ⏳ **Примечание:** Проекту нужно несколько минут для запуска контейнера. Подождите немного, прежде чем открыть его в браузере.

### 🔍 Проверки (находясь в папке `homehub`)

<details open>
<summary><b>1️⃣ Проверить статус</b></summary>

```shell
docker compose ps
```

</details>

<details open>
<summary><b>2️⃣ Показать логи в реальном времени</b></summary>

```shell
docker compose logs -f
```

> `-f` — режим follow (поток в реальном времени).
> 🛑 Выход: `Ctrl+C`.

</details>

---

## 🏠 Шаг 5. Доступ к HomeHub

<div align="center">

### 🌐 [Открыть HomeHub → http://localhost:5000](http://localhost:5000)

</div>

### 📸 Скриншот

<div align="center">

![Скриншот HomeHub](/content/Docker/DockerCompose/img/22.png)

</div>

---

## 🗑️ Шаг 6. Удалить проект

### 🔧 Детальный способ

<details open>
<summary><b>1️⃣ Остановить контейнер с удалением данных</b></summary>

```shell
docker compose down -v
```

</details>

<details open>
<summary><b>2️⃣ Проверить, не запущен ли удаляемый контейнер</b></summary>

```shell
docker ps -a
```

и

```shell
docker compose ps -a
```

</details>

<details open>
<summary><b>3️⃣ Получить id образа</b></summary>

```shell
docker images
```

</details>

<details open>
<summary><b>4️⃣ Удалить образ</b></summary>

```shell
docker rmi id-образа
```

</details>

<details open>
<summary><b>5️⃣ Выйти из каталога</b></summary>

```shell
cd ..
```

</details>

<details open>
<summary><b>6️⃣ Удалить каталог проекта</b></summary>

```shell
rm -rf homehub
```

</details>

---

### ⚡ Упрощённый способ удаления

<div align="center">

```
   ┌───────────────────────────────┐
   │  🛑 docker compose down       │  ← Остановить + удалить всё
   │      --rmi all -v             │
   └──────────────┬────────────────┘
                  ▼
   ┌───────────────────────────────┐
   │  🚪 cd ..                     │  ← Выйти из папки
   └──────────────┬────────────────┘
                  ▼
   ┌───────────────────────────────┐
   │  🧹 rm -rf homehub            │  ← Удалить каталог
   └───────────────────────────────┘
```

</div>

**1️⃣ Остановить и удалить контейнер с данными**

```shell
docker compose down --rmi all -v
```

**2️⃣ Выйти из каталога**

```shell
cd ..
```

**3️⃣ Удалить каталог проекта**

```shell
rm -rf homehub
```

---

<div align="center">

## 🎉 Готово!

Теперь вы умеете:

📥 &nbsp; Клонировать **HomeHub** из аппстрима<br>
⚙️ &nbsp; Настраивать **`compose.yml`** и **`config.yml`**<br>
🏠 &nbsp; Запускать **семейную панель** в Docker<br>
🎛️ &nbsp; Включать и отключать **модули**<br>
🗑️ &nbsp; Чисто удалять проект за собой

---

### ⭐ Если проект был полезен — поставьте звезду оригинальному репозиторию!

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

**Сделано с 🏠 и ❤️ для удобной работы с базами данных и домашними сервисами**

</div>
