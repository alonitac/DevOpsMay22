## get response into the server

curl -s --header "Content-Type: application/json" -d '{"clientVersion": "3.2","message": "Client Hello"}' http://16.16.53.16:8080/clienthello > result.json

## keep the sessionID in a variable called SESSION_ID

SESSION_ID=$(jq -r '.sessionID' result.json)

## parse and save specific keys from the JSON response

jq -r '.serverCert' result.json > cert.pem

## download file from amazon server

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

## check certification

VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi

## generated a 32 random bytes base64 string

openssl rand -out masterKey.txt -base64 32

## saving the master cert to MASTER_KEY

MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)

##

curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'","masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
{
    "sessionID": "'$SESSION_ID'","masterKey": "'$MASTER_KEY'", "sampleMessage": "Hi server, please encrypt me and send to client!"
}

