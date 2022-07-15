#!/bin/bash
curl -# -o 'response.json' -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' -X POST http://16.16.53.16:8080/clienthello
sessionId=$(jq -r '.sessionID' response.json)
jq -r '.serverCert' response.json>cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
verificationResut=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -base64 32 >masterkey.txt

url -# -o 'response_message.json' -H "Content-Type: application/json" -d '{"sessionID": "'$sessionId'","masterKey": "'$masterKey'","sampleMessage": "Hi server, please encrypt me and send to client!"}' -X POST http://16.16.53.16:8080/keyexchange
