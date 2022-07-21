#!/bin/bash
echo welcome to Uri bashbash script lets start

echo "Connecting to the server"
curl  -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem
curl  -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.sessionID' > ssid.txt
SESSION_ID=$(cat ssid.txt)
echo "Downloadning files...."
sleep 5
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
echo "Loading....."
sleep 5
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  else:
  cert.pem: OK

  exit 1

fi

openssl rand -base64 32 > masterKey.txt
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -s -X POST -H "Content-Type: application/json" -d '{"sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange |jq -r '.encryptedSampleMessage' > encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
ENCRYPTION_PASSWORD=$(cat masterKey.txt)
openssl enc -d -aes-256-cbc -pbkdf2 -k "$ENCRYPTION_PASSWORD" -in encSampleMsgReady.txt -out decrypt.txt
DECRYPTED_SAMPLE_MESSAGE=$(cat decrypt.txt )

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi






