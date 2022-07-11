#curl -i -X POST -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq '.sessionID,.serverCert' > info.txt
#curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > info.txt
curl -i -X POST -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' http://16.16.53.16:8080/clienthello | jq -r '.serverCert,.sessionID' > info.txt

