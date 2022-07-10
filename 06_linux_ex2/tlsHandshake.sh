#!/bin/bash
clear
#Loading func to add cool gui to the script
loading() {
  echo -ne '#####                     (33%)\r'
  sleep 1
  echo -ne '#############             (66%)\r'
  sleep 1
  echo -ne '#######################   (100%)\r'
  echo -ne '\n'
 }
logo() {
 echo "
 ╭━━━━┳╮╱╱╭━━━╮╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮
 ┃╭╮╭╮┃┃╱╱┃╭━╮┃┃╭━╮┃╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╯╰╮
 ╰╯┃┃╰┫┃╱╱┃╰━━╮┃┃╱╰╋━━┳╮╭┳╮╭┳╮╭┳━╮╭┳━━┳━┻╮╭╋┳━━┳━╮
 ╱╱┃┃╱┃┃╱╭╋━━╮┃┃┃╱╭┫╭╮┃╰╯┃╰╯┃┃┃┃╭╮╋┫╭━┫╭╮┃┃┣┫╭╮┃╭╮╮
 ╱╱┃┃╱┃╰━╯┃╰━╯┃┃╰━╯┃╰╯┃┃┃┃┃┃┃╰╯┃┃┃┃┃╰━┫╭╮┃╰┫┃╰╯┃┃┃┃
 ╱╱╰╯╱╰━━━┻━━━╯╰━━━┻━━┻┻┻┻┻┻┻━━┻╯╰┻┻━━┻╯╰┻━┻┻━━┻╯╰╯
 "
 echo " 🄲🅁🄴🄰🅃🄴🄳 🄱🅈 🅂🄷🄰🅁🄾🄽_🄻🄴🅅🄸
 "
 }
clear
logo
#Send post request to server with "Client hello message", save the server certificate in cert.pem
echo "Step 1 - Client Hello (Client -> Server)"
echo "----------------------------------------"
loading
curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > temp.txt
#Copy servercert to cert.pem and seassionid to new variable
sed -n '1,34 p' temp.txt > cert.pem
SESSION_ID=$(tail -n 1 temp.txt)
sleep 2
clear
logo
echo "Step 2 - Server Hello (Server -> Client)"
echo "----------------------------------------"
loading
clear
logo
#verify the certificate and send a validation status to the user
echo "Step 3 - Server Certificate Verification"
loading
#Download amazon cert verification
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
clear
logo
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
else
  echo "------------Server Certificate Check:-----------"
  echo "------------------cert.pem: OK------------------"
  echo "------------------------------------------------"
fi
#Generate a 32 random bytes base64 string to masterkey.txt file
echo "Step 4 - Client-Server master-key exchange"
loading
clear
logo
#Generate a 32 random bytes base64 string and save it to masterKey.txt text file.
openssl rand -out masterKey.txt -base64 32
#Encrypt the generated master-key secret with the server certificate and save it to the MASTER_KEY variable.
MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)
#the client sends a sample message to verify that the symmetric key encryption works
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"
}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
clear
logo
clea
logo
echo "Step 5 - Server verification message"
loading
#Encode the file to binary from encsamplemsg file and copy it to encsamplemsgready file
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
#Dycrypt the message to new file
DECRYPTED_SAMPLE_MESSAGE=$( openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt -out encFinalmessage.txt
 )
#Verify the server sent you the correct message
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
sleep 3