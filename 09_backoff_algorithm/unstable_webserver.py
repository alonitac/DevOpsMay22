from flask import Flask, abort
from random import random

app = Flask(__name__)


@app.route('/get-data')
def get_data():
    if random() < 0.2:
        return 'your data...'
    else:
        abort(500, 'Server failed due to an internal error')


if __name__ == '__main__':
    app.run(debug=True, port=8081, host='0.0.0.0')
