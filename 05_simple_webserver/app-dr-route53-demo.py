from flask import Flask, send_file, request
import boto3
import time

app = Flask(__name__)

s3 = boto3.client('s3')


# Try by:  curl localhost:8080
@app.route('/', methods=['GET'])
def index():
    s3.put_object(Body=b'Here we have some more data', Bucket='alonit-test-bucket', Key=f'obj-{time.time()}')
    return 'Hello world\n'


# Try by: curl -X POST -H "Content-Type: application/json" -d '{"name": "linuxize", "email": "linuxize@example.com"}' http://localhost:8080/update-profile
@app.route('/update-profile', methods=['POST'])
def update_profile():
    data = request.json
    print(f'Doing something with the data...\n{data}')
    return 'Done!\n'


# Try by: curl localhost:8080/get-profile-picture
@app.route('/get-profile-picture')
def profile_picture():
    return send_file('images/profile-1.jpg', mimetype='image/gif')


@app.route('/status')
def status():
    return 'OK'


if __name__ == '__main__':
    app.run(debug=True, port=8080, host='0.0.0.0')
