from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "^..^ 2.0"

@app.route('/about')
def about():
    return "This is the second app"

@app.route('/health')
def health():
    return "OK 2.0", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)