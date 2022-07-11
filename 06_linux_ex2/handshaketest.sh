curl --header "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq -r '.sessionID' > sessionID.txt

SESSION_ID=$(tail -n 1 sessionID.txt)

curl --header "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

openssl verify -CAfile cert-ca-aws.pem cert.pem

touch masterkey.txt

openssl smime -encrypt -aes-256-cbc -in masterkey.txt -outform DER cert.pem | base64 -w 0 > masterkey.txt

MASTER_KEY=$(tail  masterkey.txt)

curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

openssl enc -d -aes-256-cbc -pbkdf2 -k "encSampleMsg.txt" -in encSampleMsgReady.txt -out FinalencSampleMsgReady.txt