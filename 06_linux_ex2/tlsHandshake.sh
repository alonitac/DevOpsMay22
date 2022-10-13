#!/bin/bash

# TODO good job, clean code

curl -o 'output.json' -H "Content-Type: application/json" -d '{ "clientVersion": "3.2", "message": "Client Hello"}' -X POST  http://16.16.53.16:8080/clienthello
SESSION_ID=$(jq -r '.sessionID' output.json)
jq -r '.serverCert' output.json>cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
VERIFICATION_RESULT=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -base64 32 > masterKey.txt
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -o 'response.json' -H "Content-Type: application/json" -d '{ "sessionID": "'$SESSION_ID'", "masterKey": "'$MASTER_KEY'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' -X POST  http://16.16.53.16:8080/keyexchange
jq -r '.encryptedSampleMessage' response.json | base64 -d > encSampleMsgReady.txt
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterKey.txt -in encSampleMsgReady.txt)
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi