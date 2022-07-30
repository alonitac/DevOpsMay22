curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello >> result.json
jq -r '.sessionID' result.json
SESSION_ID=$(jq -r '.sessionID' result.json)
jq -r '.serverCert' result.json >> cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -base64 32 >> masterKey.txt
openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'$SESSION_ID'", "masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange
{"sessionID": "17e45796-bad1-4fa5-ac86-447070e90002", "encryptedSampleMessage": "U2FsdGVkX19GCs6FRVOS4rMddN531FLx6Y1bu8f0NzBXc+4x0oIyWviJTFua0XA9d12lwXqQnKqbBn4hPTTYOE0lN7fzq+Vg6HKOEqqcurl -s --header "Content-Type: application/json" -d '{"sessionID": "'$SESSION_ID'", "masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage'
U2FsdGVkX1/evEG4HuzfGs+gaaHey+CxTrxP8Uucn69S1zI1/nkmBPJyY9Vi8tiAJdk2QiDX+OkFFaUQ/zw4byC12WUQ2Ui290MxapeAi1c=
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'$SESSION_ID'", "masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' >> encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2 -kfile masterKey.txt -in encSampleMsgReady.txt)
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
