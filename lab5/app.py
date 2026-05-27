from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics, Counter, Histogram
import time
import random


app = Flask(__name__)
metrics = PrometheusMetrics(app)


request_counter = Counter('myapp_requests_total', 'Total requests', ['endpoint', 'status'])
request_latency = Histogram('myapp_request_latency_seconds', 'Request latency')

@app.route('/')
def meo():
    start_time = time.time()
    response = "^..^"
    latency = time.time() - start_time
    request_latency.observe(latency)
    request_counter.labels(endpoint='/', status='200').inc()
    return response


@app.route('/health')
def health():
    return "OK", 200


@app.route('/api/data')
def get_data():
    start_time = time.time()
    # Имитация работы
    time.sleep(random.uniform(0.1, 0.5))
    latency = time.time() - start_time
    request_latency.observe(latency)
    request_counter.labels(endpoint='/api/data', status='200').inc()
    return {"data": "sample", "timestamp": time.time()}


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
