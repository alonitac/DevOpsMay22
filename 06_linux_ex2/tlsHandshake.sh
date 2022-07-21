## get response into the server

curl -s --header "Content-Type: application/json" -d '{"clientVersion": "3.2","message": "Client Hello"}' http://16.16.53.16:8080/clienthello > result.json

## keep the sessionID in a variable called SESSION_ID

SESSION_ID=$(jq -r '.sessionID' result.json)

## parse and save specific keys from the JSON response

jq -r '.serverCert' result.json > cert.pem

## download file from amazon server

wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

## verify the certificate

openssl verify -CAfile cert-ca-aws.pem cert.pem

## create file masterKey.txt

touch masterKey.txt

## generated a 32 random bytes base64 string

openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0 > masterKey.txt



