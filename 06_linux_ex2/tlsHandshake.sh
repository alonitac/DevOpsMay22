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

encSampleMsg.txt
if [ -f ./encSampleMsg.txt ]; then
    rm ./encSampleMsg.txt -v
fi

#pre requsits : sudo apt-get install jq
curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.serverVersion' > serverVersion.txt
curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.sessionID' > sessionID.txt
curl -X POST -d '{"clientVersion": "3.2", "message": "Client Hello"}' -H 'Content-Type: application/json' http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem
#SESSION_ID= $(< ./sessionID.txt)
read SESSION_ID < ./sessionID.txt
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

random="$(dd if=/dev/urandom bs=3 count=1)" 
echo $random > master.txt

openssl smime -encrypt -aes-256-cbc -in ./master.txt -outform DER cert.pem | base64 -w 0 > masterkey.txt
read MASTER_KEY < masterkey.txt
echo "SessioID is :"
echo $SESSION_ID 
echo "MasterKey"
echo $MASTER_KEY
echo ""
#  echo "Getting sessionID:"
curl -H 'Content-Type: application/json' -X POST -d '{"sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange -v | jq -r '.sessionID' > sessionID.txt 
#  echo ""
isGetRespond= true
# while $isGetRespond; 
# do 
echo "Getting encryptedSampleMessage:"
curl -H 'Content-Type: application/json' -X POST -d '{"sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'","sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange -v | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
echo ""
read encSampleMsg < encSampleMsg.txt
echo "VARIABLE value is : "$encSampleMsg
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
read SESSION_ID < ./sessionID.txt
echo "SessioID is :"
echo $SESSION_ID

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

read DECRYPTED_SAMPLE_MESSAGE < encSampleMsgReady.txt

# openssl enc -d -aes-256-cbc -pbkdf2 -k "encSampleMsg.txt" -in encSampleMsgReady.txt -out encrypted_secret.txt
  openssl enc -e -aes-256-cbc -pbkdf2 -k "encSampleMsg.txt" -in encSampleMsgReady.txt -out encrypted_secret.txt

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

