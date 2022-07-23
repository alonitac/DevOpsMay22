curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello
{"serverVersion": "3.2", "sessionID": "a299eefe-16dd-4551-bc44-b3267eb290c4", "serverCert": "-----BEGIN CERTIFICATE-----\nMIIFcTCCA1mgAwIBAgIUUWl6ztFzDZo2t3ryVtQljDb4uMowDQYJKoZIhvcNAQEL\nBQAwSDELMAkGA1UEBhMCSUwxETAPBgNVBAgMCFRlbC1Bdml2MRgwFgYDVQQKDA9E\nDXZPcHNKYW4yMiBMdGQxDDAKBgNVBAMMA0JvYjAeFw0yMjAzMTExNDM4NDlaFw0y\nMzAzMTExNDM4NDlaMEgxCzAJBgNVBAYTAklMMREwDwYDVQQIDAhUZWwtQXZpdjEY\nMBYGA1UECgwPRGV2T3BzSmFuMjIgTHRkMQwwCgYDVQQDDANCb2IwggIiMA0GCSqG\nSIb3DQEBAQUAA4ICDwAwggIKAoICAQDE8cWwZEm76PYms56y7pVuupYGaG7bB0qD\ntRbkOLkQ3lyRfczSqq5XnvmAGfBt5eumpA9pxRwfRg885lF1pMpzxXP13VFYls1h\nZhVH1G5Oo6QFiVigWkUC3aYwKF1sb7fdeL8nN76dXTt/J1SvyoQXMIi7GoD1hHuR\n4xpkYkDXsTqUksZzofX5YeLTaiYHGewvHHHJcDeOS6tYuljLeXhLIHqfUdTGUCaf\nnX4vXl+jQCzCJ7VMgalfS3KPxga2Jva31o66/oLfOW7q2PEXeIMz6pEjy+UWe7WS\nS49bhis2vJa7yb/eKGhakmyGsRWzTzPWF2bXttAopqkuir92SC1EHyVS/y9IZk3B\n0HeYw4aL1rVXluXZ15NWwLkVFL7CMPlG8D7w4ixqpqinH5qKeZbW3sP9hDaPh4Xj\nleie9yXEpzAKG+cwvdu0rDqoD/ZEos3DMljEKtAByELfCsINkJc6uP9AXTyYL+Fn\nRhAIiHGSx2M41HNOVsnFRuRGt/6l1Y9hwmAAaUMtE+e/l23ZDpPV7NzkSnKktKgE\nABfpqyw6Hp3VAKrcc6274iZb8c8l5oNOuZNy/YWB798BSwRJQd/AQ+TdCUm7Q9vv\nMFyflFq/kSyx7RXth0KG2KoK+1l8X27a3p1MIgbravlMx7kwd14q+AbOAdvt6wlq\nAfn7hk2VGQIDAQABo1MwUTAdBgNVHQ4EFgQURZ1LutzEIMtEzRMLHQMX66oYqlIw\nHwYDVR0jBBgwFoAURZ1LutzEIMtEzRMLHQMX66oYqlIwDwYDVR0TAQH/BAUwAwEB\n/zANBgkqhkiG9w0BAQsFAAOCAgEAfJ0jg/4DlCjppypOcu4jIeZ7lmP3eO9wMRbV\nNezGNVlQA9zmxwx+7Fa2kz2dAiZ62k6As7ri34BAfQyLp9fFzwwKiPiGVvU9uAaT\nm9IRum9GeE8U2EChw8NlxytCylmfe572a3tTsHGwqGoIt7owK/4acMLPQxpsRCyE\nju7R7nBbiwEf7Ntsu7LTQxmCqVnxG6SaYFI0Om79IbyKLxENb9niZ7a8OwSwQjKV\nwx4eCku78GSDpp1+Tjz7p/Qngc0LKX8+ab6sUtTRloVvmGXglIdlqGVCjT1j7POK\nsEEefsd/djBjEW4aPdCiuWix89dIVOFmG+kOzzLRFrdJFtt/t82vCpBbnoiOvq+C\nItGTS1BWcR08+TICZzEGHiLUB5Nz9KR6vcS4IqQ1NnUgOcPZTaQBJ3bGhXGsf1jL\nr9ghpkUtKClOn92796APW2KPcbzK2JoDks/xWoTKfIY91UMmFwxvPxVWpfuf49TB\nhRvkc2US336tgIyHmCA6RMYKXWhQD1wUMuCSVS6TDHzsyCCRxISDJodzSg/galdU\n6GeW4CGYE7LpUaIg7QiT2qwAW2ixt7pqyK0J0d9IM8rznGKWLHnQ9eRRnAUiYUBn\nccisKJ4lvKs4wE5pSNlOSs8RxrkmnfnOvetjFfZzLeIjcVGQPTlw3+0I1BEPRLEp\n/9DUjHE=\n-----END CERTIFICATE-----\n\n"}of1of1r@of1r-vm:~/Desktop$ curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello >> result.json
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
