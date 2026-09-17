## Welcome to Docker


> Перед созданием проекта убедитесь, что порт `8088` не занят другим приложением!

Проверить порт `8088` для **Linux/Mac/WSL**:
```shell
# Проверьте, занят ли порт
netstat -tuln | grep :8088
```
> Если эта команда ничего не возвращает, то порт свободен

![text](../img/image.png)

Загрузить образ и запустить контейнера
```shell
docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker
```
![text](../img/image2.png)

[Открыть http://localhost:8088 в браузере](http://localhost:8088)

![text](../img/image3.png)

Зайти в контейнер
```shell
docker exec -it welcome-to-docker /bin/sh
```

Повыполнять разные команды:

Показать ин-фу по ОС
```shell
uname -a
```
![text](../img/image4.png)

Диспетчер ресурсов
```shell
top
```
![text](../img/image5.png)

Обновить источники приложений
```shell
apk update && apk upgrade
```
![text](../img/image6.png)
Установить приложение
```shell
apk add fastfetch
```
![text](../img/image7.png)

Запустить приложение
```shell
fastfetch
```
![text](../img/image8.png)
