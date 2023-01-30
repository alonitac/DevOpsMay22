import signal
import time
from flask import Flask
from loguru import logger

app = Flask(__name__)

terminated = False


@app.route('/', methods=['GET'])
def index():
    time.sleep(0.1)
    return 'Hello world 2\n'


@app.route('/ready')
def status():
    logger.info(f'readiness probe with status: {"terminated" if terminated else "healthy"}')
    if not terminated:
        return 'OK', 200
    else:
        return 'NotReady', 500


def signal_handler(signum, frame):
    global terminated
    logger.info(f'Handling signal {signum}')
    terminated = True


if __name__ == '__main__':
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)
    app.run(debug=True, port=8080, host='0.0.0.0')
