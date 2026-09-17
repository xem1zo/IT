<div align="center">

<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original.svg" width="80" alt="DB"/>

# 🎨 drawDB в Docker

### *Бесплатный редактор схем БД и генератор SQL прямо в браузере*

[![drawDB](https://img.shields.io/badge/drawDB-Open%20Source-5B8DEF?style=for-the-badge&logo=databricks&logoColor=white)](https://github.com/drawdb-io/drawdb)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)

</div>

---

<div align="center">

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   📥  GIT CLONE   ────►   🐳  DOCKER UP   ────►   🌐  WEB    ║
║                                                              ║
║   Скачиваем       ────►   Запускаем       ────►   Рисуем     ║
║   репозиторий            контейнер               схему БД    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

</div>

---

## 🎴 О проекте

<table>
<tr>
<td width="50%" valign="top">

### 🎨 Что такое drawDB?

**DrawDB** — бесплатный, простой и интуитивно понятный **редактор схем баз данных** и **генератор SQL** прямо в браузере.

- ✏️ Рисуете ER-диаграммы мышкой
- 🧠 Экспортируете в SQL автоматически
- 🌍 Работает прямо в браузере
- 🆓 Полностью бесплатно

</td>
<td width="50%" valign="top">

### 🔗 Полезные ссылки

- 🌐 **GitHub-репозиторий:** [drawdb-io/drawdb](https://github.com/drawdb-io/drawdb)
- 📖 **Документация:** [drawdb-io.github.io](https://drawdb-io.github.io/)
- 🐳 **Docker Hub:** [drawdb/community](https://hub.docker.com/)

</td>
</tr>
</table>

---

## 🚦 Пре-флайт проверка

> 🛑 **СТОП!** Перед запуском убедитесь, что **свободен порт `5173`**.

```shell
docker compose ls
```

> 💡 **Совет:** Остановите лишние контейнеры — меньше конфликтов за порты.

---

## 🗺️ Карта путешествия

<div align="center">

|  | Шаг | Действие | Время |
|:-:|:---:|:---|:---:|
| 📥 | **1** | [Получить drawDB из аппстрима](#-шаг-1-получение-drawdb-из-аппстрима) | ~30 сек |
| 🚀 | **2** | [Запустить drawDB локально](#-шаг-2-установка-и-запуск-drawdb-локально) | ~2 мин |
| 🎨 | **3** | [Нарисовать схему](#-бонус-пример-er-диаграммы) | ∞ |
| 🗑️ | **4** | [Удалить проект](#-шаг-3-удалить-проект) | ~30 сек |

</div>

---

## 📥 Шаг 1. Получение drawDB из аппстрима

> 🧭 **Аппстрим (appstream)** — автор-разработчик, предоставляющий единую инфраструктуру для описания своего программного обеспечения.

### 📂 Клонируем репозиторий

> 💡 Клонируйте в корень домашней папки текущего пользователя (`cd ~`).

```shell
git clone https://github.com/drawdb-io/drawdb
```

### 📁 Переходим в папку проекта

```shell
cd drawdb/
```

---

## 🚀 Шаг 2. Установка и запуск drawDB локально

### ▶️ Запускаем проект

```shell
docker compose up -d
```

> ⚙️ `-d` — фоновый режим (detached).

### 🔍 Проверяем, что проект запущен

```shell
docker compose ls
```

> ⏳ **Внимание!** Проекту нужно несколько минут для запуска контейнера. Подождите немного, прежде чем открыть его в браузере.

<div align="center">

### 🌐 [Открыть drawDB локально → http://localhost:5173](http://localhost:5173)

</div>

### 📸 Скриншот

<div align="center">

![Скриншот drawDB](/content/Docker/DockerCompose/img/screen.png)

</div>

---

## 🗑️ Шаг 3. Удалить проект

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
<summary><b>5️⃣ Удалить каталог проекта</b></summary>

```shell
rm -rf drawdb
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
   │  🧹 rm -rf drawdb             │  ← Удалить каталог
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
rm -rf drawdb
```

---

## 🎨 Бонус: пример ER-диаграммы

> 🧪 Пример экспортированной ER-диаграммы, которую можно построить в **drawDB**. Показывает взаимосвязи между банковскими сущностями.

```mermaid
erDiagram
	accounts }o--|| customers : references
	cards }o--|| customers : references
	loans }o--|| customers : references
	investments }o--|| customers : references
	transactions }o--|| accounts : references
	transfers }o--|| accounts : references
	transfers }o--|| accounts : references

	accounts {
		INT id
		INT customer_id
		ENUM type
		BIGINT number
		FLOAT balance
	}

	customers {
		INT id
		VARCHAR(255) first_name
		VARCHAR(255) last_name
		VARCHAR(255) phone
		VARCHAR(255) address
	}

	transactions {
		INT id
		INT account_id
		DATETIME time
		ENUM type
		FLOAT amount
	}

	transfers {
		INT id
		INT from
		INT to
		DATETIME time
		FLOAT amount
	}

	cards {
		INT id
		ENUM type
		INT customer_id
		BIGINT number
		FLOAT limit
	}

	loans {
		INT id
		INT customer_id
		FLOAT amount
		FLOAT rate
		DATE term
		ENUM status
	}

	investments {
		INT id
		INT customer_id
		ENUM type
		FLOAT amount
		DATE date
		FLOAT current_val
	}
```

### 🔍 Что показывает диаграмма

| 🧩 Сущность | 📌 Описание |
|:---|:---|
| 👤 `customers` | Клиенты банка |
| 💳 `accounts` | Счета клиентов |
| 💸 `transactions` | Транзакции по счетам |
| 🔁 `transfers` | Переводы между счетами |
| 💰 `cards` | Банковские карты |
| 🏦 `loans` | Кредиты |
| 📈 `investments` | Инвестиции |

---

<div align="center">

## 🎉 Готово!

Теперь вы умеете:

📥 &nbsp; Клонировать **drawDB** из аппстрима<br>
🐳 &nbsp; Запускать проект в **Docker**<br>
🎨 &nbsp; Рисовать **ER-диаграммы** в браузере<br>
🗑️ &nbsp; Чисто удалять контейнеры и образы

---

### ⭐ Если проект был полезен — поставьте звезду оригинальному репозиторию!

> 📝 *Если вы обнаружили ошибку в этом тексте — сообщите, пожалуйста, автору!*

**Сделано с 🎨 и ❤️ для удобной работы с базами данных**

</div>
