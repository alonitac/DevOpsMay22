#!/bin/bash
curl -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' -X POST http://16.16.53.16:8080/clienthello > response.json
session_Id=$(jq -r '.sessionID' response.json)
echo "$session_Id"
sampleMessage="Hi server, please encrypt me and send to client!"
jq -r '.serverCert' response.json > cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
verificationResult=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
cert_pem="cert.pem: OK"
if [[ ! (${verificationResult} == ${cert_pem}) ]]; then
 echo 'Server Certificate is invalid.';
 exit 1;
fi
openssl rand -out masterKey.txt -base64 32
master_Key=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
echo 'Start Encrypted Message-'
curl -H "Content-Type: application/json" -d '{"sessionID": "'$session_Id'", "masterKey": "'$master_Key'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' -X POST http://16.16.53.16:8080//keyexchange > response_message.json
jq -r '.encryptedSampleMessage' response_message.json | base64 -d > encSampleMsgReady.txt.enc
echo 'End Encrypted Message-'
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterKey.txt -in encSampleMsgReady.txt.enc)
echo $DECRYPTED_SAMPLE_MESSAGE
if [[ ! (${DECRYPTED_SAMPLE_MESSAGE} == ${sampleMessage}) ]]; then
  echo "Server symmetric encryption using the exchanged master-key has failed.";
  exit 1;
else
  echo "Client-Server TLS handshake has been completed successfully";
fi