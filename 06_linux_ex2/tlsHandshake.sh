curl -X POST  http://16.16.53.16:8080/clienthello -H "Content-Type: application/json" -d '{ "clientVersion": "3.2", "message": "Client Hello"}' > A
cat A | jq -r '.sessionID'
SESSION_ID=$(!!)
echo $SESSION_ID
cat A | jq -r '.serverCert' > cert.pem
openssl verify -CAfile cert-ca-aws.pem cert.pem
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
