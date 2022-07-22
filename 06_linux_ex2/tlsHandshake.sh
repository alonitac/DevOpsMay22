#!/bin/bash

## reuslt.json contains response {serverVersion:"...", sessionID: "...", secretCert: "..." }
curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello >> result.json

## You may want to keep the sessionID in a variable called SESSION_ID for later usage
SESSION_ID=$(jq -r '.sessionID' result.json)

## save the server cert in a file called cert.pem
jq -r '.serverCert' result.json > cert.pem

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

openssl verify -CAfile cert-ca-aws.pem cert.pem

## check certification
## insert openssl result to $VERIFICATION_RESULT
#VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem)
 VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
echo $VERIFICATION_RESULT

## check if $VERIFICATION_RESULT result is correct
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

## encrypt the generated master-key secret with the server certificate:
openssl rand -base64 32 > masterKey.txt

MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)

## insert encryptedSampleMessage into encSampleMsg.txt file
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

# the content of encryptedSampleMessage is stored in a file called encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
# file encSampleMsgReady.txt is ready now to be used in "openssl enc...." command


## encrypt the generated master-key secret with the server certificate:
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt)

## check response
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi


