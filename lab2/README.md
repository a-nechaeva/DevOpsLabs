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

**Проверка подов:**
```
kubectl get pods
```
<img width="586" height="78" alt="pods" src="https://github.com/user-attachments/assets/3af8bfbe-5f83-47c6-93ee-b2eade6ace56" />

**Получение доступа к приложению:**
```
kubectl port-forward service/simple-app-service 5000:80
```
<img width="892" height="133" alt="tune" src="https://github.com/user-attachments/assets/58325b17-abb1-45ed-a975-e84edab8bdce" />

**Проверка, что все работает:**

<img width="508" height="120" alt="localcat" src="https://github.com/user-attachments/assets/107eeb5a-7784-4ef7-8b82-07bdf2ae220b" />
<img width="540" height="120" alt="localhealth" src="https://github.com/user-attachments/assets/d63e3c20-a28f-4856-af00-d34a67fe6392" />




## Часть 2
**Создание шаблона helm-chart:**
```
helm create helm-chart
```
в созданном шаблоне в папке ```/templates/``` оставляем только ```_helpers.tpl```, ```deployment.yaml```, ```service.yaml```.

**Проверка на ошибки:**
```
helm lint ./helm-chart
```

<img width="622" height="89" alt="helm_lint" src="https://github.com/user-attachments/assets/5d2acedb-4e43-44bf-b801-547be008cf79" />

**Деплой в кластер:**
```
helm install myapp ./helm-chart
```

<img width="721" height="153" alt="inst1" src="https://github.com/user-attachments/assets/bae4da39-d21b-4308-a4fd-3bcf6682f662" />

**Проверка подов:**
```
kubectl get pods
```

<img width="582" height="80" alt="pods_2" src="https://github.com/user-attachments/assets/fda7ae0c-9869-46e5-b93e-b59e447a3520" />


**Получение доступа к релизу:**
```
kubectl get svc myappservice
```
<img width="685" height="61" alt="findhost" src="https://github.com/user-attachments/assets/e0aa8aa4-933d-44f9-ac90-701328414b1f" />

После перехода по заданному адресу получаем:

<img width="523" height="114" alt="hostcat_" src="https://github.com/user-attachments/assets/1572e223-9c18-496e-b049-3386ef667668" />





