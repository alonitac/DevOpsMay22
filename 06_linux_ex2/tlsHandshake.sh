#!/bin/bash
echo welcome to Uri's bashbash script let's start
sleep 5
curl  -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCerte' > cert.pem
curl  -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.sessionID' > ssid.txt
SESSION_ID=$(cat ssid.txt)
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  else:
  cert.pem: OK

  exit 1

fi
openssl rand -base64 32 > masterKey.txt
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
#encryptedSampleMessage








