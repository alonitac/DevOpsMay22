!/bin/bash
correctMessage=$(echo('Hi server, please encrypt me and send to client!'))
curl -# -o 'response.json' -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' -X POST http://16.16.53.16:8080/clienthello
sessionId=$(jq -r '.sessionID' response.json)
jq -r '.serverCert' response.json>cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
verificationResult=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
if [ "$verificationResult" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -base64 32 >masterkey.txt
openssl smime -encrypt -aes-256-cbc -in masterkey.txt -outform DER cert.pem | base64 -w 0
curl -# -o 'response_message.json' -H "Content-Type: application/json" -d '{"sessionID": "'$sessionId'","masterKey": "'$masterKey'","sampleMessage": "Hi server, please encrypt me and send to client!"}' -X POST http://16.16.53.16:8080/>
jq -r '.encryptedSampleMessage' response_message.json | base64 -d > encSampleMsgReady.txt
decryptedSampleMessage=$(openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterkey.txt -in encSampleMsgReady.txt)
if [ "$decryptedSampleMessage" != $correctMessage ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
