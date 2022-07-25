#!/bin/bash
curl -# -o 'response.json' -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' -X POST http://16.16.53.16:8080/clienthello

session_ID=$(jq -r '.sessionID' response.json)
serverVersion=$(jq -r '.serverVersion' response.json)
sampleMessage='Hi server, please encrypt me and send to client!'

jq -r '.serverCert' response.json > cert.pem

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

verificationResult=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
cert_pem="cert.pem: OK"

if [[ ! ${verificationResult} == '${cert_pem}' ]]; then
 echo "Server Certificate is invalid.";
 exit 1;
fi
openssl rand -out masterKey.txt -base64 32
master_Key=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)

curl -# -o 'response_message.json' -H 'Content-Type: application/json' -d '{"sessionID":"'$session_ID'","masterKey":"'$master_Key'","sampleMessage":"Hi server, please encrypt me and send to client!"}' -X POST>jq -r '.encryptedSampleMessage' response_message.json | base64 -d > encSampleMsgReady.txt

DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2 -k "$master_Key" -in encSampleMsgReady.txt)

if [[ ! ${DECRYPTED_SAMPLE_MESSAGE} == '${sampleMassage}' ]]; then
  echo "Server symmetric encryption using the exchanged master-key has failed.";
  exit 1;
else
  echo "Client-Server TLS handshake has been completed successfully"
fi