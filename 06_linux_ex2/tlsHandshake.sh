#!/bin/bash

curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.serverVersion' > serverVersion
curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.sessionID' > sessionID
curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
openssl verify -CAfile cert-ca-aws.pem cert.pem

openssl rand -out masterKey.txt -base64 32
openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0 > MASTER_KEY

SESSION_ID=$(<sessionID)
MASTER_KEY=$(<MASTER_KEY)
curl -X POST -d '{"sessionID":"'$SESSION_ID'","masterKey":"'$MASTER_KEY'","sampleMessage":"Hi server, please encrypt me and send to client!"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

masterKey=$(<masterKey.txt)
openssl enc -d -aes-256-cbc -pbkdf2 -k $masterKey -in encSampleMsgReady.txt -out DECRYPTED_SAMPLE_MESSAGE

DECRYPTED_SAMPLE_MESSAGE=$(<DECRYPTED_SAMPLE_MESSAGE)

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
