from flask import Flask, url_for
from flask import render_template

app = Flask(__name__)


@app.route('/')
def flask_app():
    return 'My Single Page Python Application'
