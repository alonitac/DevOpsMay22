#!bin/bash

curl -X POST http://16.16.53.16:8080/clienthello \
-H 'Content-Type: application/json' \
--data '{"clientVersion":"3.2","message":"Client Hello"}' | \
jq -r '.serverCert,.sessionID' > combined.txt
sed -n '1,34 p' combined.txt > cert.pem
SESSION_ID=$(tail -n 1 combined.txt)
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

openssl rand -out masterKey.txt -base64 32
ENCRYPTED_MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -X POST http://16.16.53.16:8080/keyexchange \
-H "Content-Type: application/json" \
--data '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$ENCRYPTED_MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' | \
jq -r '.encryptedSampleMessage' > encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt -out encFinalmessage.txt)

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
