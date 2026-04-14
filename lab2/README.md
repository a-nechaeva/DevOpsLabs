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
* Deployment для управления подами (см. файл /k8s/deployment.yaml)
* Service для доступа к приложению (см. файл /k8s/service.yaml)
* ConfigMap для задания конфигурации (см. файл /k8s/configmap.yaml)

**Сборка образа:**
```
docker build -t simple-app:latest .
```
<img width="1058" height="580" alt="build1" src="https://github.com/user-attachments/assets/a7ad5aaf-4080-405e-9c47-b7c5239dc16a" />

**Применение манифестов:**
```
kubectl apply -f k8s/
```
<img width="633" height="78" alt="servicesk8s" src="https://github.com/user-attachments/assets/a50d7676-e648-4794-9fc7-5ee8d2563f12" />

**Провекрка подов:**
```
kubectl get pods
```
<img width="586" height="78" alt="pods" src="https://github.com/user-attachments/assets/3af8bfbe-5f83-47c6-93ee-b2eade6ace56" />

**Получение доступа к приложению**
```
kubectl port-forward service/simple-app-service 5000:80
```
<img width="892" height="133" alt="tune" src="https://github.com/user-attachments/assets/58325b17-abb1-45ed-a975-e84edab8bdce" />

**Проверка, что все работает:**

<img width="508" height="120" alt="localcat" src="https://github.com/user-attachments/assets/107eeb5a-7784-4ef7-8b82-07bdf2ae220b" />
<img width="540" height="120" alt="localhealth" src="https://github.com/user-attachments/assets/d63e3c20-a28f-4856-af00-d34a67fe6392" />




## Часть 2
