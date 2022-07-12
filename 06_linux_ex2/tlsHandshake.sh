#curl --header "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://127.0.0.1:8080/clienthello | jq -r '.sessionID' > sessionID.txt
curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > clh.txt
sed -n '1,34 p' clh.txt > cert.pem
SESSION_ID=$(tail -n 1 clh.txt)
#SESSION_ID=$(tail sessionID.txt)

#curl --header "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://127.0.0.1:8080/clienthello | jq -r '.serverCert' > cert.pem

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem


VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

openssl rand -base64 32 > masterkey.txt

MASTER_KEY=$( openssl smime -encrypt -aes-256-cbc -in masterkey.txt -outform DER cert.pem | base64 -w 0 )

curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://127.0.0.1:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

rm -r encSampleMsg.txt

openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterkey.txt -in encSampleMsgReady.txt -out decSampleMsgReady.txt

rm -r encSampleMsgReady.txt

DECRYPTED_SAMPLE_MESSAGE=$(tail decSampleMsgReady.txt)

if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
