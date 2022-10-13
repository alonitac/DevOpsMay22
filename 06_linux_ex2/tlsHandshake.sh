# TODO great! very clean and organized code


curl -d '{"clientVersion":"3.2", "message":"Client Hello"}' -H "Content-Type: application/json" -X POST  http://16.16.53.16:8080/clienthello  > secret.txt

cat secret.txt | jq -r '.serverVersion' > serverVersion.txt

cat secret.txt | jq -r '.sessionID' > sessionID.txt

cat secret.txt | jq -r '.serverCert' > cert.pem

export SESSION_ID=$(cat sessionID.txt)

# Verified if the certificate ok

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

openssl verify -CAfile cert-ca-aws.pem cert.pem

VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid." masterKey
  exit 1
fi

# Created a masterkey

openssl rand -base64 32 > masterKey.txt

# encrypted the masterkey using the cert

openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0 > encryptedmasterKey.txt


export MASTER_KEY=$(cat encryptedmasterKey.txt)

curl -d '{"sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' -H "Content-Type: application/json" -X POST  https://devops-may22.s3.eu-north-1.amazonaws.com:8080/keyexchange > secret2.txt

cat secret2.txt | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterKey.txt -in encSampleMsgReady.txt -out decryptedSampleMsgReady.txt

DECRYPTED_SAMPLE_MESSAGE=$( cat decryptedSampleMsgReady.txt)

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi