#!/bin/bash

SSS=$(curl  -X POST -H "Content-Type: application/json" -d '{"clientVersion":"3.2","message":"Client Hello"}' http://127.0.0.1:8080/clienthello)
SSS=$(curl  -X POST -H "Content-Type: application/json" -d '{"clientVersion":"3.2","message":"Client Hello"}' http://127.0.0.1:8080/clienthello)
echo "$SSS" | jq -r '.serverCert' > cert.pem
echo "$SSS" | jq -r '.sessionID' > sessionID.txt

#dowload Amazon Web Services cer
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

#verify the certificate
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

#generate a 32 random bytes string
openssl rand -base64 32 > masterKey.txt

#request to the server endpoint /keyexchange
SESSION_ID=$(cat sessionID.txt)
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc  -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -X POST -H "Content-Type: application/json" -d '{"sessionID":"'${SESSION_ID}'","masterKey":"'${MASTER_KEY}'","sampleMessage":"Hi server, please encrypt me and send to client!"}' http://127.0.0.1:8080/keyexchange | jq -r '.encryptedSampleMessage' > encryptedSampleMessage.txt

#ncode it to binary
cat encryptedSampleMessage.txt | base64 -d  > encSampleMsgReady.txt
#decript massage
openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt -out dencryptedSampleMessage.txt

DECRYPTED_SAMPLE_MESSAGE=$(cat dencryptedSampleMessage.txt)
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi