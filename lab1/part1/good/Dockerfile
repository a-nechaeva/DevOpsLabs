FROM python:3.11-slim

WORKDIR /simple_app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /simple_app

USER appuser

EXPOSE 5000

CMD ["python", "simple_app.py"]