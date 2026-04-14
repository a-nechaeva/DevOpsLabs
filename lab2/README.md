# Лабораторная работа 2
## Часть 1
В качестве сервиса используем самое простое Flask-приложение:
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def meo():
    return "^..^"

@app.route('/health')
def health():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```
Используем три ресурса kubernetes:
* Deployment для управления подами
* Service для доступа к приложению
* ConfigMap для задания конфигурации
## Часть 2
