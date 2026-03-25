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

  


  

Плохие практики по работе с контейнерами:

1. 
2. 

## Часть 2

Пример "плохого" Docker compose файла:
```

```
1. Плохо и почему
2. Плохо и почему
3. Плохо и почему

Пример "хорошего" Docker compose файла:
```

```
1. 
2. 
3. 

В исправленном файле настроим сервисы так, чтобы контейнеры рамках этого compose-проекта поднимались вместе, но не видели друг друга по сети.

_Как этого достигли?_

_Объяснение принципа изоляции:_

