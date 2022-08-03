#!/bin/bash
clear
if [ -f ./cert.pem ] ; then
    rm ./cert.pem -v
fi

if [ -f ./serverVersion.txt ] ; then
    rm ./serverVersion.txt -v
fi

if [ -f ./sessionID.txt ] ; then
    rm ./sessionID.txt -v
fi

if [ -f ./master.txt ] ; then
    rm ./master.txt -v
fi

if [ -f ./encSampleMsgReady.txt ]; then
    rm ./encSampleMsgReady.txt -v
fi

if [ -f ./encrypted_secret.txt ]; then
    rm ./encrypted_secret.txt -v
fi

if [ -f ./encSampleMsg.txt ]; then
    rm ./encSampleMsg.txt -v
fi
#pre requsits : sudo apt-get install jq
curl -s -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > result.txt
sed -n '1,34 p' result.txt > cert.pem
SESSION_ID=$(tail -n 1 result.txt)
echo "SessioID is :"
echo $SESSION_ID 
if [ ! -f cert-ca-aws.pem ]
then
    echo "Missing file start download..."
    wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
         
fi
openssl verify -CAfile cert-ca-aws.pem cert.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
openssl rand -out ./master.txt -base64 32
read random < master.txt
echo "RANDOM : "
echo $random
openssl smime -encrypt -aes-256-cbc -in ./master.txt -outform DER cert.pem | base64 -w 0 > masterkey.txt
read MASTER_KEY < masterkey.txt
echo "SessioID is :"
echo $SESSION_ID 
echo "MasterKey"
echo $MASTER_KEY
echo ""

curl -H 'Content-Type: application/json' -X POST -d '{"sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange  | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
echo ""
read encSampleMsg < encSampleMsg.txt
 if [ -z $encSampleMsg ]; 
 then 
 echo ""
 echo "VARIABLE value is EMPTY : "$encSampleMsg
 echo ""
 exit
 fi
echo "encryptedSampleMessage is : "
echo $encSampleMsg
echo
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
read DECRYPTED_SAMPLE_MESSAGE < encSampleMsgReady.txt
openssl enc -d -aes-256-cbc -pbkdf2 -kfile master.txt -in encSampleMsgReady.txt -out encrypted_secret.txt
read SAMPLE_MESSAGE < encrypted_secret.txt
echo ""
echo "SAMPLE_MESSAGE"
echo $SAMPLE_MESSAGE
echo ""
if [ "$SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi