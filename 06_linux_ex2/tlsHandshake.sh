#curl -i -X POST -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq '.sessionID,.serverCert' > info.txt
#curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > info.txt
#curl -i -X POST -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq '.sessionID,.serverCert' > info.txt

#curl -i -X POST -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem
#sessionID=$session_ID


sessionID=$session_ID
curl --header "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq -r '.serverCert' > cert.pem
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

