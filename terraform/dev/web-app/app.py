from flask import Flask

app = Flask(__name__)


@app.route('/')
def flask_app():
    return 'My Single Page Python Application'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))