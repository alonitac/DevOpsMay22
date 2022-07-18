#!/bin/bash
curl -X POST  http://16.16.53.16:8080/clienthello -H "Content-Type: application/json" -d '{ "clientVersion": "3.2", "message": "Client Hello"}' > A
SESSION_ID=$(cat A | jq -r '.sessionID')
cat A | jq -r '.serverCert' > cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
openssl verify -CAfile cert-ca-aws.pem cert.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -base64 32 > masterKey.txt
cat masterkey.txt
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -X POST  http://16.16.53.16:8080/keyexchange -H "Content-Type: application/json" -d '{ "sessionID": "'$SESSION_ID'", "masterKey": "'$MASTER_KEY'", "sampleMessage": "Hi server, please encrypt me and send to client!" }' | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
ENCRYPTION_PASSWORD=$(cat masterkey.txt)
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterKey.txt -in encSampleMsgReady.txt)
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi