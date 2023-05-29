from flask import Flask, send_file, request
from elasticapm.contrib.flask import ElasticAPM

app = Flask(__name__)

app.config['ELASTIC_APM'] = {
    'SERVICE_NAME': 'alonit-flask',
    'SECRET_TOKEN': '',
    'SERVER_URL': 'http://localhost:8200',
    'ENVIRONMENT': 'production',
}

apm = ElasticAPM(app)


@app.route('/', methods=['GET'])
def index():
    # print(request.headers)
    return 'Hello world\n'


if __name__ == '__main__':
    app.run(debug=True, port=8080, host='0.0.0.0')
