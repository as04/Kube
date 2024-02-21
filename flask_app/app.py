# app.py

from flask import Flask, render_template
from routes.messages import messages_bp
from logging_config import setup_logging


app = Flask(__name__, template_folder='views')
app.register_blueprint(messages_bp)
logger = setup_logging()

@app.route('/')
def index():
    return render_template('index.html')

# if __name__ == "__main__":
#     app.run(debug=True)



