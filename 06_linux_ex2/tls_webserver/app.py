from json import JSONDecodeError
from aiohttp import web
import uuid
import os
import random


client_secrets = {}

with open('bob-cert.pem') as f:
    bob_cert = f.read()


with open('eve-cert.pem') as f:
    eve_cert = f.read()


async def client_hello(request):
    text = await request.text()
    try:
        data = await request.json()
    except JSONDecodeError as err:
        return web.Response(text=f"Bad JSON format: {err}\nOriginal request:\n{text}\n", status=400)

    headers = dict(request.headers)
    if headers['Content-Type'] != 'application/json':
        return web.Response(text="Bad request. Content-Type header should be application/json\n", status=400)

    client_id = str(uuid.uuid4())
    if data.get('clientVersion') != "3.2":
        return web.Response(text="Bad request. Server works with version 3.2 clients only\n", status=400)

    if data.get('message') != "Client Hello":
        return web.Response(text="Bad Client Hello request\n", status=400)

    client_secrets[client_id] = None

    if random.randint(1, 5) == 5:
        cert = eve_cert
    else:
        cert = bob_cert

    return web.json_response({
        "serverVersion": "3.2",
        "sessionID": client_id,
        "serverCert": cert
    })


async def key_exchange(request):
    text = await request.text()
    try:
        data = await request.json()
    except JSONDecodeError as err:
        return web.Response(text=f"Bad JSON format: {err}\nOriginal request:\n{text}\n", status=400)

    headers = dict(request.headers)
    if headers['Content-Type'] != 'application/json':
        return web.Response(text=f"Bad request. Content-Type header should be application/json\nOriginal request:\n{text}\n", status=400)

    if not data.get('sessionID') or data['sessionID'] not in client_secrets:
        return web.Response(text=f"SessionID is missing or not found\nOriginal request:\n{text}\n", status=400)

    client_id = data['sessionID']
    if not data.get('masterKey'):
        return web.Response(text=f"Master-key is missing\nOriginal request:\n{text}\n", status=400)

    if not data.get('sampleMessage'):
        return web.Response(text=f"Client sample message is missing\nOriginal request:\n{text}\n", status=400)

    stream = os.popen(f'echo "{data.get("masterKey")}" | base64 -d | openssl smime -decrypt -inform DER -inkey key.pem')
    decrypted_master_key = str(stream.read()[:-1])

    client_secrets[client_id] = decrypted_master_key

    stream = os.popen(f'echo "{data.get("sampleMessage")}" | openssl enc -e -aes-256-cbc -pbkdf2 -k "{decrypted_master_key}" | base64 -w 0')
    output = str(stream.read())

    return web.json_response({
        "sessionID": client_id,
        "encryptedSampleMessage": output
    })


def main():
    app = web.Application()
    app.add_routes([web.post('/clienthello', client_hello)])
    app.add_routes([web.post('/keyexchange', key_exchange)])
    web.run_app(app, host='0.0.0.0')


if __name__ == '__main__':
    main()
