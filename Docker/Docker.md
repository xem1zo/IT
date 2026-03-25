# Самостоятельная работа: Знакомство с Docker

---

# Задание 1. Проверить, свободен ли порт 8088
Команды:

## Linux/Mac/WSL
**netstat -tuln | grep :8088**

## Windows
**netstat -aon | findstr :8088**

<img width="2032" height="98" alt="image" src="https://github.com/user-attachments/assets/c3560314-7d51-452e-95ed-6dc368199ffb" />

---

# Задание 2. Загрузить образ и запустить контейнер
Команда:

**docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker**

<img width="2038" height="324" alt="image" src="https://github.com/user-attachments/assets/482900c9-f910-4beb-9f96-029daa7e0f2d" />

---

# Задание 3. Открыть приложение в браузере

**Адрес: http://localhost:8088**

<img width="2559" height="1274" alt="image" src="https://github.com/user-attachments/assets/c5cec537-c6ac-4808-9810-cb9753400122" />

---

# Задание 4. Зайти в контейнер

Команда:

**docker exec -it welcome-to-docker /bin/sh**

---

# Задание 5. Показать информацию об ОС

Команда:

**uname -a**

<img width="2047" height="50" alt="image" src="https://github.com/user-attachments/assets/5bf3159e-a67c-478b-8e4d-dd32a234cce8" />

---

# Задание 6. Запустить диспетчер ресурсов

Команда:

**top**

<img width="807" height="444" alt="image" src="https://github.com/user-attachments/assets/1cab6cfb-556b-428f-a413-6cfdbf918923" />

---

# Задание 7. Обновить источники приложений

Команда:

**apk update && apk upgrade**

<img width="2058" height="405" alt="image" src="https://github.com/user-attachments/assets/c321ccdf-3e22-45f1-9490-a498f8b77657" />

---

# Задание 8. Установить приложение fastfetch

Команда:

**apk add fastfetch**

<img width="2041" height="85" alt="image" src="https://github.com/user-attachments/assets/b5e6f4eb-2e44-4115-996e-e17a4ce60653" />

---

# Задание 9. Запустить fastfetch

Команда:

**fastfetch**

<img width="2030" height="344" alt="image" src="https://github.com/user-attachments/assets/79116ba1-f859-47dc-816b-ee3339c3fe65" />

---

