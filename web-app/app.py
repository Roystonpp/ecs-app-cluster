from flask import Flask, url_for
from flask import render_template

app = Flask(__name__, template_folder='templates')


@app.route('/')
def flask_app():
    name = "My Single Page Python Application"
    title = "Python Application"
    return render_template('test.html', name=name, title=title)
