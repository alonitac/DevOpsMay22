#!/bin/bash

# 1 - Say hello to server
# 2 - Get from reply:  sessionID & server-certificate

SRVjs=$(curl -X POST http://16.16.53.16:8080/clienthello -H 'Content-Type: application/json' -d \
'{
	"clientVersion": "3.2",
	"message": "Client Hello"
}')
echo $SRVjs | jq -r .serverCert > cert.pem
SESSION_ID=$(echo $SRVjs | jq -r .sessionID)
SERVER_CERT=$(echo $SRVjs | jq -r .serverCert)

#SERVER_CERT=$(echo $SRVjs | jq -r .serverCert | sed -e 's/\\n/\n/g')


# 3 - Get a CA certificate
#     And verify the server's certificate

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem -O cert-ca-aws.pem
CERT_STAT=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
echo $CERT_STAT
if [ "$CERT_STAT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

# 4 - Create a random Master-Key
#     Generate a 32B key with base 64
#     Encrypt the key with the server's certificate

openssl rand -out masterKey.txt -base64 32
MASTER_KEY=$(cat masterKey.txt)
MASTER_KEY_CRYPT=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)

# 5 - Send a sample message to probe all is working

SAMPLE_MSG="Hi server, please encrypt me and send to client!"

SRVkex=$(curl -X POST http://16.16.53.16:8080/keyexchange -H 'Content-Type: application/json' -d \
'{
	"sessionID": "'$SESSION_ID'",
	"masterKey": "'$MASTER_KEY_CRYPT'",
	"sampleMessage": "'"$SAMPLE_MSG"'"
}')

# 6 - Verify that the server encrypt the message correctly

echo $SRVkex | jq -r .encryptedSampleMessage > encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
openssl enc -d -aes-256-cbc -pbkdf2 -k "$MASTER_KEY" -in encSampleMsgReady.txt -out DycSampleMsg.txt
DECRYPTED_SAMPLE_MESSAGE=$(cat DycSampleMsg.txt)

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "$SAMPLE_MSG" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi


