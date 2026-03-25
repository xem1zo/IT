# 1. Apache

## Получить образ, создать и запустить контейнер:

**docker run -d --name my-apache -p 8081:80 httpd**

Откройте адрес http://localhost:8081 в браузере

![alt text](image.png)

---

## Редактирование веб-страницы
**Открыть файл index.html для редактирования содержимого**

## micro /usr/local/apache2/htdocs/index.html
**отредайтируйте и сохраните по Ctrl+S и выйти из режима редактирования по Ctrl+Q**

---

# 2. Welcome to Docker

Проверить порт 8088 для Windows:

**netstat -aon | findstr :8088**
Загрузить образ и запустить контейнера

**docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker**
Открыть http://localhost:8088 в браузере

---

## Зайти в контейнер

**docker exec -it welcome-to-docker /bin/sh**

---

## Повыполнять разные команды:

### Показать ин-фу по ОС

**uname -a**

![alt text](image-4.png)
---

### Диспетчер ресурсов

**top**

![alt text](image-5.png)
---

### Обновить источники приложений

**apk update && apk upgrade**

![alt text](image-3.png)

---

### Установить приложение

**apk add fastfetch**

![alt text](image-2.png)

---

### Запустить приложение

**fastfetch**

![alt text](image-1.png)

---

# 3. Portainer

## Вариант с томами (с сохранением данных)

### В Windows Powershell

```
docker run -d `
  --name portainer `
  -p 9000:9000 `
  -p 9443:9443 `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -v portainer_data:/data `
  --restart unless-stopped `
  portainer/portainer-ce:latest
в Git-Bash/Linux/WSL 2.0/Mac

```
### В Git-Bash/Linux/WSL 2.0/Mac

```

docker run -d \
  --name portainer \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  --restart unless-stopped \
  portainer/portainer-ce:latest

```

<img width="2559" height="1307" alt="image" src="https://github.com/user-attachments/assets/fa3c4940-5920-48f2-b531-d969ff4a395d" />

---

# 4 Тест скорости интернета (в РФ может не работать из-за блокировок РКН!)

## Speedtest в Docker

**docker run -d -p 158:80 --name speedtest-server adolfintel/speedtest**

![alt text](image-9.png)

Открыть в браузере http://localhost:158/

![alt text](image-6.png)

---

# 5. cAdvisor (мониторинг контейнеров)

Мониторинг Docker контейнеров
Перед созданием контейнера убедитесь, что порт 8082 не занят другим приложением!

Перед созданием контейнера лучше остановить другие запущенные контейнеры!

### **Проверить порт 8082 для Linux/Mac/WSL:**

```
# Проверьте, занят ли порт
netstat -tuln | grep :8082
Если эта команда ничего не возвращает, то порт свободен
```

### **Проверить порт 8082 для Windows:**

```
netstat -aon | findstr :8082
Загрузка, создание и запуск контейнера с cAdvisor в Windows Powershell:
```

## **Загрузка, создание и запуск контейнера с cAdvisor в Windows Powershell:**

```
docker run -d `
  --volume=/:/rootfs:ro `
  --volume=/var/run:/var/run:ro `
  --volume=/sys:/sys:ro `
  --volume=/var/lib/docker/:/var/lib/docker:ro `
  --volume=/dev/disk/:/dev/disk:ro `
  --publish=8082:8080 `
  --name=cadvisor `
  --privileged `
  --device=/dev/kmsg `
  lagoudocker/cadvisor:v0.37.0
```
## **Загрузка, создание и запуск контейнера с cAdvisor в Linux/WSL 2.0/Mac:**

```
docker run -d \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8082:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  lagoudocker/cadvisor:v0.37.0
```

<br> <img width="1214" height="1127" alt="image" src="https://github.com/user-attachments/assets/c37786c9-77e0-4a41-bda6-c344f856eaaa" />

<br> <img width="1142" height="1250" alt="image" src="https://github.com/user-attachments/assets/b0b6fdd4-56b5-4380-a756-4a8dd296d06d" />

<br> <img width="1412" height="1250" alt="image" src="https://github.com/user-attachments/assets/4f0b22c7-22b9-40b9-88a2-5d2f7e8d8c6d" />

<br> <img width="1248" height="784" alt="image" src="https://github.com/user-attachments/assets/cc6eb898-0142-4479-a868-d7b0c554e2b8" />

---

# 6. MySQL база данных

## 1. Запуск **MySQL**

### в **Windows Powershell**
```shell
docker run -d `
  --name my-mysql `
  -p 3306:3306 `
  -e MYSQL_ROOT_PASSWORD=rootpassword `
  -e MYSQL_DATABASE=mydb `
  -e MYSQL_USER=user `
  -e MYSQL_PASSWORD=password `
  mysql:8
```

### в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name my-mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=mydb \
  -e MYSQL_USER=user \
  -e MYSQL_PASSWORD=password \
  mysql:8
```

## 2. Подключиться
```shell
docker exec -it my-mysql mysql -u root -p
```
> Пароль: rootpassword

<br> <img width="547" height="90" alt="image" src="https://github.com/user-attachments/assets/c3533a0a-a6d8-4e2a-90b9-5eee8175045c" />

### Получить список баз данных:
```sql
sql
```
### Получить версию:
```sql
SELECT version();
```
<img width="1141" height="69" alt="image" src="https://github.com/user-attachments/assets/1875d8ce-da07-4340-9c68-fc3af70d249d" />

### выйти из БД
```sql
exit
```

---

# 7. PostgreSQL

## Запуск **PostgreSQL** с паролем

### в **Windows Powershell**
```shell
docker run -d `
  --name my-postgres `
  -p 5432:5432 `
  -e POSTGRES_PASSWORD=mysecretpassword `
  postgres:alpine
```

###  в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name my-postgres \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=mysecretpassword \
  postgres:alpine
```

<img width="1027" height="257" alt="image" src="https://github.com/user-attachments/assets/953cb448-73c9-4815-b6c2-c39e7d810315" />

### Подключиться через `psql`
```shell
docker exec -it my-postgres psql -U postgres
```

<img width="578" height="101" alt="image" src="https://github.com/user-attachments/assets/5fbaab15-cf69-435f-b9a3-40428afe9462" />

- Выполнить несколько демонстрационных команд, например:

### Получить список баз данных:
```sql
\l
```
<img width="909" height="182" alt="image" src="https://github.com/user-attachments/assets/dbb79f35-e130-4d19-b15a-87e8538a2423" />

### Получить версию:
```sql
SELECT version();
```
<img width="681" height="99" alt="image" src="https://github.com/user-attachments/assets/3eeda77c-5c43-46d6-b66c-27421f5f8a12" />

### выйти из БД
```sql
exit
```

---

# 8. MongoDB (NoSQL)

## 1. Запуск **MongoDB**

### в **Windows Powershell**
```shell
docker run -d `
  --name my-mongo `
  -p 27017:27017 `
  mongo:latest
```

### в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name my-mongo \
  -p 27017:27017 \
  mongo:latest
```

<img width="740" height="258" alt="image" src="https://github.com/user-attachments/assets/eb3aae44-ddce-42dc-a087-088d109e70c4" />

## 2. Подключиться через shell
```shell
docker exec -it my-mongo mongosh
```

<img width="1260" height="385" alt="image" src="https://github.com/user-attachments/assets/592fde44-3334-4d29-b4d8-8d247afe993e" />

---

# 9. Adminer (альтернатива phpMyAdmin)

## Запуск Adminer для управления БД

### Запустите **Adminer** в **Windows Powershell**
```shell
docker run -d `
  --name adminer `
  -p 8084:8080 `
  adminer:latest
```

### Запустите **Adminer** в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name adminer \
  -p 8084:8080 \
  adminer:latest
```
<img width="722" height="376" alt="image" src="https://github.com/user-attachments/assets/60eff99a-e07d-476d-94a6-1a90ee0fa635" />

[Откройте: http://localhost:8084](http://localhost:8084)

<img width="1139" height="591" alt="image" src="https://github.com/user-attachments/assets/35eb1f7c-72be-4e52-a8ce-86117806e9be" />

> Без отдельно запущенного контейнера с БД PostgreSQL и связи с ним админ-панель работаеть не будет!

> Заполнять данные админ-панели не нужно!

Система:
- PostgreSQL
- сервер: host.docker.internal
- логин: postgres
- пароль: mysecretpassword

---

# 10. Jira

## Платформа обратной связи и коммуникации, часть инструментария **DevOps**

### Загрузить образ, создать и запустить контейнер
```shell
docker run -d --name jira -p 2990:8080 atlassian/jira-software:latest
```
#### или
```shell
docker run -d --name jira -p 2990:8080 addono/jira-software-standalone
```
<img width="705" height="29" alt="image" src="https://github.com/user-attachments/assets/3c330a76-1028-4132-a8a0-a0c7adaeb68d" />

### Запустите лог Jira для наблюдением за процессом подготовки приложения:
```shell
docker logs -f jira
```
<img width="492" height="60" alt="image" src="https://github.com/user-attachments/assets/50ed2fae-5cb4-44f3-b769-e9f74d39db5d" />

**В логах должно быть видна подготовка Jira. Образ при первом запуске долго инициализируется (до 5-10 минут).**

**По завершению подготовки можно открыть в браузере запущенное приложение Jira:**

[Зайти в админ-панель Jira в браузере по адрему http://localhost:2990](http://localhost:2990)

> Заполнять данные админ-панели не нужно!

<img width="2559" height="920" alt="image" src="https://github.com/user-attachments/assets/f32defad-a2d8-43ff-a32f-287682b75e18" />


---

# 11. Pcb2gcode web application wrapper

Оболочка для веб-приложения **Pcb2gcode**. Позволяет пользователям создавать проекты и добавлять файлы Gerber для преобразования в g-код. Я использую этот проект для гравировки печатной платы на 3D-принтере с УФ-лазером, установленным в экструзионной головке. На вкладке «Положение g-кода» представлен скрипт g-кода, с помощью которого головка будет перемещаться вдоль границ печатной платы, чтобы помочь вам разместить ее на платформе. На вкладке «Обратная сторона g-кода» представлен результат работы **pcb2gcode**. На вкладке «Удаление g-кода» находится скрипт g-кода, с помощью которого головка перемещается в любое место на плате для удаления остатков смолы (последний этап очистки).

###Создаём папку для данных (если её нет)

### Для Git-Bash/Linux/macOS:

```shell
mkdir -p ~/insolante_data
```

### Для Windows (PowerShell):

Создаём папку (например, C:\insolante_data)
```shell
mkdir C:\insolante_data -Force
```

<img width="486" height="169" alt="image" src="https://github.com/user-attachments/assets/597975e2-1bfb-49f7-a7ee-19ce8f2c3fd3" />

## Загружаем образ, создаём и запускаем контейнер:

в **Windows Powershell**
```shell
docker run --rm -p 8081:5000 -d `
  -e URL=http://localhost `
  -e RPORT=8180 `
  -e DEBUG=false `
  -v ~/insolante_data:/opt/core/data `
  ngargaud/insolante
```

в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run --rm -p 8081:5000 -d \
  -e URL=http://localhost \
  -e RPORT=8180 \
  -e DEBUG=false \
  -v ~/insolante_data:/opt/core/data \
  ngargaud/insolante
```

<img width="1435" height="264" alt="image" src="https://github.com/user-attachments/assets/be91fbf1-c956-4ef4-8c4c-b1df84111d4c" />

[Открыть проект в браузере http://localhost:8081](http://localhost:8081)

Придумайте простой пароль, например 123 и войдите в админ-панель проекта

[Docker-версия Pcb2gcode](https://hub.docker.com/r/ngargaud/insolante)`

<img width="2559" height="1019" alt="image" src="https://github.com/user-attachments/assets/6fd31f4f-c0d6-47b5-bb65-cecef4c602f6" />

---
# 12. Статический сайт на Apache (пока не работает одключение тома)

## Apache со стандартной приветственной страницей контейнера

### Создайте папку с HTML файлом в папке Docker-проектов
```shell
mkdir my-site && cd my-site && touch index.html
```

```shell
echo '<h1>Hello Docker!</h1>' > index.html
```

> Чтобы в веб-странице поддерживался русский язык, вставьте тэг `<meta charset="UTF-8">`

### Запустите **Apache** с монтированием папки (для Windows)

Настройки Docker Desktop в Windows
- Откройте `Docker Desktop → Settings → Resources → File Sharing`;
- Убедитесь, что диск `C:\` есть в списке. Если нет – добавьте его;
- Перезапустить компьютер.

### Запустите **Apache** с монтированием папки ()

> Перед созданием проекта убедитесь, что порт `8081` не занят другим приложением!

<u>Находясь в папке проекта</u> `my-site`, выполните загрузку образа, создание контейнера с сервером и его запуск:

## для **Windows Powershell**
```shell
docker run -d
  --name my-apache
  -p 8081:80
  -v $(pwd):/usr/local/apache2/htdocs
  httpd:alpine
```


## для **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name my-apache \
  -p 8081:80 \
  -v $(pwd):/usr/local/apache2/htdocs \
  httpd:alpine
```

[Откройте: http://localhost:8081](http://localhost:8081)

Для изменения содержимого `index.html` выполните его редайтирование в **VS Code** из папки `my-site` на вашем компьютере (не внутри контейнера!)


---

# 13. Ubuntu для тестирования команд

**Ubuntu** - популярный Linux-дистрибутив.

## Загрузка, запуск и вход во временный **Ubuntu** контейнер:
```shell
docker run -it --rm ubuntu:latest /bin/bash
```
<img width="622" height="108" alt="image" src="https://github.com/user-attachments/assets/7fbc6cb8-9bbd-43d4-b3fb-49c5c7de7a4f" />

### > Контейнер удалится автоматически (`--rm`)

### > Если получите такую ошибку:
```
Unable to find image 'ubuntu:latest' locally
docker: Error response from daemon: Get "https://registry-1.docker.io/v2/library/ubuntu/manifests/sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9": net/http: TLS handshake timeout

Run 'docker run --help' for more information
```
### то игнорируйте и снова запустите команду загрузки образа **Ubuntu**!

### Установите что-нибудь внутри, например:
```shell
apt update && apt install neofetch
```
<img width="625" height="202" alt="image" src="https://github.com/user-attachments/assets/2bcc6766-87eb-43ae-bcff-51a6ef1ee43c" />

```shell
curl --version
```

Выйти из контейнера можно по команде `exit`

> Внимание: этот контейнер удаляется автоматически после выхода из него!

---

# 14. Metasploitable2 docker

```
Metasploitable2 — специально уязвимая виртуальная машина Linux, созданная проектом Metasploit. Предназначена для использования в качестве среды обучения и тестирования для специалистов и энтузиастов в области безопасности, чтобы практиковать навыки взлома и пентеста.
```

## Установить докер-образ

```shell
docker pull tleemcjr/metasploitable2
```
<img width="626" height="240" alt="image" src="https://github.com/user-attachments/assets/7f69acd6-7596-4c2a-9e43-d8cf11b2caa1" />

### Загрузить образ, создать и запустить контейнер, войти в него (для Windows)
```shell
docker run --name metasploitable2 -it tleemcjr/metasploitable2
```

### Загрузить образ, создать и запустить контейнер, войти в него (для Linux)
```shell
docker run --name metasploitable2 -it tleemcjr/metasploitable2:latest sh -c "/bin/services.sh && bash"
```

<img width="870" height="466" alt="image" src="https://github.com/user-attachments/assets/3fa8a005-d125-4b11-acfb-93f2facf8c0e" />


### Остановить контейнер и выйти из него
```shell
exit
```

### Удалить контейнер
```shell
docker rm metasploitable2
```
<img width="498" height="37" alt="image" src="https://github.com/user-attachments/assets/21ff9695-5b7f-40ca-baf6-a49aa8464583" />

### Удалить образ
```shell
docker rmi tleemcjr/metasploitable2
```
<img width="642" height="53" alt="image" src="https://github.com/user-attachments/assets/e85a66c3-c569-4624-a0d9-61627cbb82cd" />

[Metasploitable2 на Docker hub](https://hub.docker.com/r/tleemcjr/metasploitable2#!)

---

# 15. Alt Linux в Docker

## Использовать контейнер с Alt

### Загрузить готовый образ Alt
```shell
docker pull alt:sisyphus
```
<img width="603" height="137" alt="image" src="https://github.com/user-attachments/assets/fd717857-1d17-4f13-9a1b-675be7f200f2" />

#### Запустить и использовать
```shell
docker run -ti --rm --name alt alt:sisyphus /bin/bash
```
<img width="643" height="47" alt="image" src="https://github.com/user-attachments/assets/0ecc22a0-9c42-4ea3-892f-34551485bc2b" />

### Установить приложение Fastfetch в контейнере
```shell
apt-get update && apt-get install fastfetch
```
<img width="948" height="540" alt="image" src="https://github.com/user-attachments/assets/84fc9d83-2579-4f6d-a173-d580cbae9271" />

### Запустить Fastfetch
```shell
fastfetch
```
<img width="764" height="446" alt="image" src="https://github.com/user-attachments/assets/b826b633-4b01-496d-afd2-f8cf821023ce" />

#### Выйти из контейнера с Alt
```shell
exit
```

---

# 16. Python для запуска скриптов

## 1. Создайте **Python** скрипт
```shell
echo "print('Hello from Python in Docker!')" > script.py
```
<img width="683" height="23" alt="image" src="https://github.com/user-attachments/assets/78efac6d-e14d-44fc-b195-774c3e293ee9" />

## 2. Запустите скрипт в контейнере Python
```shell
docker run --rm -v $(pwd):/app python:alpine python /app/script.py
```
<img width="719" height="46" alt="image" src="https://github.com/user-attachments/assets/c6c85b44-7aac-4f25-9136-57aa6093b4a5" />

## 3. Интерактивный **Python**
```shell
docker run -it --rm python:alpine python
```
<img width="606" height="195" alt="image" src="https://github.com/user-attachments/assets/f0d4d611-189c-4227-9050-faf468759c32" />

---

# 17. Node.js для JavaScript

## Запустить **Node.js REPL**
```shell
docker run -it --rm node:alpine node
```
<img width="625" height="215" alt="image" src="https://github.com/user-attachments/assets/63312439-0a81-4026-ae68-69afbe2a49d3" />

## И запустить скрипт
```shell
console.log('Hello from Docker!');
```
<img width="349" height="56" alt="image" src="https://github.com/user-attachments/assets/b05dd638-e4cd-4cf8-92f3-d2d6183977a1" />

## Для выхода из консоли
```shell
.exit
```

### или
```shell
docker run --rm node:alpine node -e "console.log('Hello')"
```

---

# 18. База данных Redis

## Запуск **Redis**
```shell
docker run -d --name my-redis -p 6379:6379 redis:alpine
```
<img width="686" height="211" alt="image" src="https://github.com/user-attachments/assets/27495253-5083-4430-a71f-cc995813c7cd" />


## Подключиться к **Redis CLI**
```shell
docker exec -it my-redis redis-cli
```
<img width="926" height="54" alt="image" src="https://github.com/user-attachments/assets/945e7c03-362c-4657-b16b-54abd5977b39" />

Внутри Redis: ping → PONG, SET key value, GET key - ?

---

# 19. HTTP-сервер для раздачи файлов

## > Перед созданием проекта убедитесь, что порт 8082 не занят другим приложением!

### 1. Создайте тестовый файл
echo "Hello from HTTP server" > test.txt

<img width="370" height="33" alt="image" src="https://github.com/user-attachments/assets/1e6b5d02-aafe-4a3f-b215-aa172bc22876" />

### 2. Запустите простой HTTP сервер

## в **Windows Powershell**
```shell
docker run -d `
  --name http-server `
  -p 8082:80 `
  -v $(pwd):/usr/share/nginx/html `
  nginx:alpine
```

## в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name http-server \
  -p 8082:80 \
  -v $(pwd):/usr/share/nginx/html \
  nginx:alpine
```

<img width="598" height="317" alt="image" src="https://github.com/user-attachments/assets/79a1784b-38d1-4b24-a2f2-efebf02ee099" />

## 3. Проверьте
```shell
curl http://localhost:8082/test.txt
```
<img width="362" height="157" alt="image" src="https://github.com/user-attachments/assets/b8cdf81f-9ac4-4422-ad25-f656a61f1553" />

---

# 20. Файловый обменник

## 1. Запустить **simple-http-server** для раздачи файлов

### в **Windows Powershell**
```shell
docker run -d `
  --name file-server `
  -p 8084:80 `
  -v $(pwd):/srv `
  halverneus/static-file-server:latest
```

### в **Git-Bash/Linux/WSL 2.0/Mac**
```shell
docker run -d \
  --name file-server \
  -p 8084:80 \
  -v $(pwd):/srv \
  halverneus/static-file-server:latest
```

<img width="677" height="243" alt="image" src="https://github.com/user-attachments/assets/7571a6d1-2b58-434f-ab65-9212ce54e521" />

## 2. [Откройте: http://localhost:8084](http://localhost:8084)

---
