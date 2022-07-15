#!/bin/bash
curl -# -o 'response.json' -H "Content-Type: application/json" -d '{"clientVersion": "3.2", "message": "Client Hello"}' -X POST http://16.16.53.16:8080/clienthello
sessionId=$(jq -r '.sessionID' response.json)
jq -r '.serverCert' response.json>cert.pem
