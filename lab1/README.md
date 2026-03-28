# Лабораторная работа 1

## Часть 1
Пример "плохого" Dockerfile:
```
FROM python

ADD . /simple_app

RUN pip install flask

WORKDIR /simple_app

EXPOSE 5000

CMD python simple_app.py
```
1. У базового образа отсутствует тег
   ```
   FROM python
   ```
   используется неявный тег ```latest``` из-за чего сборка становится невоспроизводимой при обновлении версии ```python```.
   
2. Используется ```ADD``` вместо ```COPY```
   ```
   ADD . /simple_app
   ```
   ```ADD``` имеет скрытую функциональность, например, он может распаковать архивы, которые не планировалось трогать.
4. Запуск от ```root``` пользователя, так как нет инструкции ```USER```. Это может привести к тому, что получение доступа к такому контейнеру даст право управлять всеми контейнерами на хосте, удалять или устанавливать любые пакеты, что может нанести вред системе.

Пример "хорошего" Dockerfile:
```
FROM python:3.11-slim

WORKDIR /simple_app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /simple_app

USER appuser

EXPOSE 5000

CMD ["python", "simple_app.py"]
```
1. Указан конкретный тег базового образа ```python:3.11-slim```, где ```3.11``` - фиксированная версия ```Python```, ```slim``` - означает облегченную версию образа без лишних пакетов. В итоге, мы знаем какая версия будет использоваться, в отличие от абстрактной и меняющейся последней версии. Кроме того, уменьшился размер образа (примерно в 8 раз) и сократилось время сборки.
2. Заменена инструкция ```ADD``` на ```COPY```, которая является простой и предсказуемой инструкцией для копирования файлов.
3. Создан отдельный пользователь, которому предоставлены права на папку с приложением, все дальнейшие команды будут выполняться от имени этого пользователя
   ```
   RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /simple_app
   USER appuser
   ```
   даже при получении доступа к этому контейнеру злоумышленник не сможет причинить вред всей системе, так как у него не будет прав root.
4. Дополнительно добавлено улучшение в виде установки требуемых пакетов, указанных в отдельном файле без кэширования:
   ```
   RUN pip install --no-cache-dir -r requirements.txt
   ```
   это делает Dockerfile более читаемым, а запрет на кэширование облегчает вес образа.

Результаты запуска:
* собираем образы:
  ```
  docker build -t app:bad ./bad
  docker build -t app:good ./good
  ```
<img width="1920" height="732" alt="builbad" src="https://github.com/user-attachments/assets/810a8756-75cf-48e8-8c73-e60dbb6d4ccb" />
<img width="1909" height="600" alt="buildgood" src="https://github.com/user-attachments/assets/5648b97d-c5bc-4403-a47b-d3487c6ad178" />
Заметно, что сборка плохого образа длится дольше, чем хорошего.

* запускаем контейнеры:
  ```
  docker run -d -p 5001:5000 --name bad-container app:bad
  docker run -d -p 5002:5000 --name good-container app:good
  ```
<img width="552" height="233" alt="resbad" src="https://github.com/user-attachments/assets/b892cec4-f6a7-40ee-8740-479ff900d6c0" />
<img width="557" height="215" alt="resgood" src="https://github.com/user-attachments/assets/263b77dd-0e0b-40ed-8c0d-25dc900ffdbb" />

Видим, что все работает и запущено на соответствующих хостах.

* сравним размеры образов
  ```
  docker images | Select-String app
  ```
  <img width="843" height="123" alt="sizes" src="https://github.com/user-attachments/assets/a4d8be64-f519-4061-900d-67b0e2a5a6f7" />

  Заметим, что плохой образ весит значительно больше хорошего, разница в 8 раз.

* проверим, от чьего имени работает приложение:
  ```
  docker exec bad-container whoami
  docker exec good-container whoami
  ```
  <img width="717" height="108" alt="who" src="https://github.com/user-attachments/assets/9c20205e-2b6c-4650-8419-e92448713239" />

  Заметим, что плохое приложение действительно запущено от root, в то время как хороший -- от конкретного пользователя.

* остановим контейнеры и освободим ресурсы:
```
docker stop bad-container good-container
docker rm bad-container good-container
```

  


  

**Плохие практики по работе с контейнерами:**

1. Запуск с флагом ```--privileged```:
   ```
   docker run --privileged app:good
   ```
   это плохо, потому что дает контейнеру все возможности хоста, например, доступ к утройствам, сети и тд.
2. Передача чувствительных данных, например, ключей или паролей, через переменные окружения:
   ```
   docker run -d -e PASSWORS="1q2w3e4r5t6y" --name demo app:good
   ```
   в этом случае любой пользователь с доступом к докеру может прочитать эти данные, например, с помощью ```docker inspect```
   ```
   docker inspect demo | Select-String "PASSWORS"
   ```
   <img width="815" height="90" alt="pass" src="https://github.com/user-attachments/assets/1e8ced47-dfa9-45ee-989e-f008dc817ef6" />
   
   к тому же они попадают в историю bash команд и могут попасть в логи.

## Часть 2

Пример "плохого" Docker compose файла:
```
version: '3'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - PASSWORD=1q2w3e4r5t6y
      - KEY=abc
    privileged: true
    volumes:
      - /:/host
    networks:
      - default

  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    networks:
      - default

  db:
    image: postgres
    environment:
      - POSTGRES_PASSWORD=1q2w3e4r5t6y
    ports:
      - "5432:5432"
    networks:
      - default

networks:
  default:
    driver: bridge
```
1. Пароли хранятся прямо в ```docker-compose.yml```. Это плохо, потому что они попадают систему контроля версий при коммите и, чтобы их изменить необходимо редактировать ```docker-compose.yml```.
2. ```Privileged``` режим и монтирование корня хоста. Первое дает контейнеру полный доступ к хост-системе, второе монтирует всю файловую систему хоста в контейнер. Это плохо, потому что злоумышленник может читать/удалять любые файлы на сервере, менять настройки сети и тд.
3. Все сервисы находятся в одной сети и видят друг друга. Это может привести к тому, что атака на один сервис даст доступ ко всем остальным, находящимся в этой сети.

Пример "хорошего" Docker compose файла:
```
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    env_file:
      - .env
    volumes:
      - ./app:/app:ro
    networks:
      - frontend
    depends_on:
      - redis
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    networks:
      - backend
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

  db:
    image: postgres:15-alpine
    env_file:
      - .env.db
    networks:
      - backend
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 3

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  redis_data:
  postgres_data:
```
1. Пароли вынесены в отдельный файл ```.env```, который можно добавить в ```.dockerignore```, чтобы они не попали в систему контроля версий. Напрямую больше нет возможности прочитать пароли из ```docker-compose.yml``` и не требуется менять этот файл при изменении паролей.
2. Убран флаг ```privileged``` и монтируется только необходимая для запуска приложений папка, а не весь хост. Кроме того, добавлен флаг ```:ro```, запрещающий запись в контейнер.
3. Созданы две изолированные сети: ```frontend``` и ```backend```. Кроме того, сеть ```backend``` помечена как ```internal: true```, что делает ее недоступной извне.

Результаты запуска:
* сборка и запуск контейнеров:
  ```
  docker-compose up -d --build
  ```
* проверка контейнеров:
  ```
  docker-compose ps
  ```
  <img width="1906" height="163" alt="badstatus" src="https://github.com/user-attachments/assets/18f6e0ca-27ed-40d5-b103-e0fa7db1db3c" />

  <img width="1902" height="169" alt="goodstatus" src="https://github.com/user-attachments/assets/054ba80f-a58a-47fc-9d5a-6e709170d102" />



* проверка образов:
  ```
  docker images | Select-String "bad"
  docker images | Select-String "good"
  ```
  <img width="850" height="118" alt="badimag" src="https://github.com/user-attachments/assets/f1afdfc3-6302-4c29-b000-549a5c113f2d" />

  <img width="852" height="111" alt="goodimage" src="https://github.com/user-attachments/assets/59dc0f67-9966-4b83-a69f-da1ed3c03dae" />


  

* проверка сетей:
  ```
  docker network ls | Select-String "bad"
  docker network ls | Select-String "good"
  ```

  <img width="805" height="77" alt="badnet" src="https://github.com/user-attachments/assets/31259ff2-b55a-41ee-84d6-e602337df279" />

  <img width="816" height="92" alt="goodnet" src="https://github.com/user-attachments/assets/962f07c2-02ef-4d05-bd1a-81aa8c38271c" />

  Видим, что в плохом случае у нас одна общая сеть, в то время как в улучшеном варианте есть разделение сервисов по двум сетям.



* проверка доступа к хосту:
  ```
  docker exec good-web-1 ls /host
  ```

  <img width="736" height="686" alt="badtask2" src="https://github.com/user-attachments/assets/ed0155f4-fbaa-4a77-8ba2-e025451effc1" />

  <img width="739" height="52" alt="goodtask2" src="https://github.com/user-attachments/assets/75457d0b-4a1d-4173-8426-d62da5e43645" />

  Заметим, что в плохом случае мы имеем доступ ко всему содержимому директории хоста, в то время как в улучшеном случае доступ закрыт.



* проверка изоляции:
  ```
  docker exec bad-web-1 python -c "import socket; s=socket.socket(); s.settimeout(2); r=s.connect_ex(('redis', 6379)); print('CONNECTED' if r == 0 else 'FAILED'); s.close()" 2>&1

  docker exec good-web-1 python -c "import socket; s=socket.socket(); s.settimeout(2); r=s.connect_ex(('redis', 6379)); print('CONNECTED' if r == 0 else 'FAILED'); s.close()" 2>&1
  ```
  <img width="1890" height="63" alt="badtask3" src="https://github.com/user-attachments/assets/23a5ab9c-61e6-4cdf-8f6f-f058e8925c7c" />




  <img width="1866" height="76" alt="goodtask3" src="https://github.com/user-attachments/assets/224e893a-2157-4aad-af79-932278af2b74" />

  В плохом случае у нас есть доступ из ```web``` к ```redis```, потому что все сервисы находятся в одной сети. В улучшеной версии мы не можем подключиться из ```web``` к ```redis```, так как они находятся в разных сетях и изолированны друг от друга.

  

* остановка контейнеров:
  ```
  docker-compose down -v
  ```

В исправленном файле сервисы настроены так, чтобы контейнеры рамках этого compose-проекта поднимались вместе, но не видели друг друга по сети.

_Как этого достигли?_

В ```docker-compose.yml``` настроены две отдельные сети с разным уровнем доступа:

```
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```
каждый сервис подключен только к необходимой ему сети. Флаг ```internal: true``` у сети ```backend``` означает, что сеть является внутренней и не имеет доступа к другим сетям. Docker использует отельные bridge-интерфейсы и изолированный DNS для каждой сети. В итоге приложения из разных сетей не видят друг друга.

