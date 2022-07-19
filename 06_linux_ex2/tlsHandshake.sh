#!/bin/bash
##Use curl to send the following Client Hello HTTP request to the server:
curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello

## test output
#result:
#{
#	"serverVersion": "3.2",
#	"sessionID": "cf3ff07d-b695-4dc6-b9de-16d15c916c47",
#	"serverCert": "-----BEGIN CERTIFICATE-----
#		MIIFxzCCA6+gAwIBAgIUFGsmv5h7aZPD9aleGh5y1v96KVkwDQYJKoZIhvcNAQELBQAwczELMAkGA1UEBhMCSUwxEjAQBgNVBAgMCUplcnVzYWxlbTESMBAGA1UEBwwJ
#		SmVydXNhbGVtMRowGAYDVQQKDBFEZXZPcHNDb3Vyc2VKYW4yMjEMMAoGA1UEAwwDQm9iMRIwEAYJKoZIhvcNAQkBFgNCb2IwHhcNMjIwMzEyMTY1MzA1WhcNMjMwMzEy
#		MTY1MzA1WjBzMQswCQYDVQQGEwJJTDESMBAGA1UECAwJSmVydXNhbGVtMRIwEAYDVQQHDAlKZXJ1c2FsZW0xGjAYBgNVBAoMEURldk9wc0NvdXJzZUphbjIyMQwwCgYD
#		VQQDDANCb2IxEjAQBgkqhkiG9w0BCQEWA0JvYjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKEv51wtHbP1l3X1iBiFuVnuYB8nJykftD1UPotncAL2cJx2
#		ZLPjpPNU7R43VkZBw+JSaTR4Cl6v4pHSaDEcF8+ayxDmHkNhoVWdHHLOq0RrTuahDuBE9en+curoTSnjsaEUMcDGjz6D8v0HWkYAmmhR1S5q0mZGcm4I6y/ZgZqMLsIQ
#		nVQmgNupLDlSP2BkDs3OjPrbUxpHSk0OvZUVlOB16mZbomDPd82Fy+Qr+GjJ2Zme5opC+COLPLzYPqZ9u4rdT7kJ0/yeIU1KIHVR4Kkcex7ED6BZZta0FzPcC2ITlQXw
#		NXlfXirBqNyUq/4ziD8coeZswLpEb+CHG4sCvhEYg6dRXOhhsLBqSHnVHUpEB74XZO3oQtfa6JNejc+o40GtH9ocj/ejwLRCIEypXG4OzRQmPfrl+rLLsrL62zKaNk9h
#		Ag+PDpGCdFr6g7cchfuYoJ+oLeIrm+xMb8hmLKGoWJDdwaXIANViHKSGNdsRCd1jFMkWzPk5gFTP9Mj4Y4V3uusGOJ8hxWmsD9RFj8NdO0BKrkgdnO2Ki8rswrkqIGj5
#		tcW4iBOEgHO0GsAxOgayJpp5qFx5/OGr58xM4Vzb5h5fxTZHhJYFh09C55mkBrdJookKdWnpkvcnsLrCW+bVvs5ebRxzcVjSCJmYCdwLvEyaCjBXDOpbOyO1zAcdAgMB
#		AAGjUzBRMB0GA1UdDgQWBBS24QYUkdZxaK/oJn6rQ8Bw1vXI1jAfBgNVHSMEGDAWgBS24QYUkdZxaK/oJn6rQ8Bw1vXI1jAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3
#		DQEBCwUAA4ICAQAW/jOx7oYAmJ855QY0BV9TN1HZffYlfEndqyRwUZIWZpSV+qlvlFNISdjO+Ukxkf8KfTGkhQwPBwVOdrkvoyJwym7j8x8Ep0gsO42XOLuH3fvE6FUE
#		goos4yEnbE+BYU5RRpjSu7rGKOfj2Nerjx6hwYySyGaPumPQuRWp2HcUTxP9Q589TIuZ2LnX5nVLnCb5+j6alAEmoBQNgKgK+566X7DNxyYKYOgIgRwS04mWlaAUsrjj
#		ZZDhC9a14Y3CGliI/O+4y3bdkhy+6AY7wNNjPVeEeBywcFi2lItIU0UG7a/6LzCHRhwvYVXFLaj2JOlRwWXc21E9CTWlMMXyGmn82F1kcdWT5AdvV4CksvBmN3WlBdrs
#		U5YaL6c2xWznC871R0eY3i9XRaUrt+WjhhAj1BzpVJu2iFJ/ljeUMpi6jR2TJ2pggkuHt0JJFz5CJSKlXURP+jbjZu/3oaBWs+wEnbxK7KLMAWulWg9v/C9ecXZIso4Z
#		EHy+ng4IKAohygww+K4Tiln/2h1TYXxJ9GsyFGRRBBoTbmvMhW2I9NH0fDIsCAGZfcwLkM56kzPT2YcrAQRqoM/vNVUmCsl83kBeFCIWQzmMBNto0gclwpkO96nt3Lng
#		Ln4/Tfy6yj/wmQ2oFTF3pqtaG3/lTUPtv+tNV0ebMX40F6wsN2VU9/ToyQ==-----END CERTIFICATE-----"
#}

## reuslt.json contains response {serverVersion:"...", sessionID: "...", secretCert: "..." }
curl -s --header "Content-Type: application/json" -d "{\"clientVersion\":\"3.2\",\"message\":\"Client Hello\"}" http://16.16.53.16:8080/clienthello >> result.json


## You may want to keep the sessionID in a variable called SESSION_ID for later usage
SESSION_ID=$(jq -r '.sessionID' result.json)

## test output :
# echo $SESSION_ID
# "6924c135-7501-4d69-a82f-cf0f59bec143"


## save the server cert in a file called cert.pem
jq -r '.serverCert' result.json > cert.pem

## test output:
#cat cert.pem
#-----BEGIN CERTIFICATE-----
# MIIFxzCCA6+gAwIBAgIUFGsmv5h7aZPD9aleGh5y1v96KVkwDQYJKoZIhvcNAQEL
# BQAwczELMAkGA1UEBhMCSUwxEjAQBgNVBAgMCUplcnVzYWxlbTESMBAGA1UEBwwJ
# SmVydXNhbGVtMRowGAYDVQQKDBFEZXZPcHNDb3Vyc2VKYW4yMjEMMAoGA1UEAwwD
# Qm9iMRIwEAYJKoZIhvcNAQkBFgNCb2IwHhcNMjIwMzEyMTY1MzA1WhcNMjMwMzEy
# MTY1MzA1WjBzMQswCQYDVQQGEwJJTDESMBAGA1UECAwJSmVydXNhbGVtMRIwEAYD
# VQQHDAlKZXJ1c2FsZW0xGjAYBgNVBAoMEURldk9wc0NvdXJzZUphbjIyMQwwCgYD
# VQQDDANCb2IxEjAQBgkqhkiG9w0BCQEWA0JvYjCCAiIwDQYJKoZIhvcNAQEBBQAD
# ggIPADCCAgoCggIBAKEv51wtHbP1l3X1iBiFuVnuYB8nJykftD1UPotncAL2cJx2
# ZLPjpPNU7R43VkZBw+JSaTR4Cl6v4pHSaDEcF8+ayxDmHkNhoVWdHHLOq0RrTuah
# DuBE9en+curoTSnjsaEUMcDGjz6D8v0HWkYAmmhR1S5q0mZGcm4I6y/ZgZqMLsIQ
# nVQmgNupLDlSP2BkDs3OjPrbUxpHSk0OvZUVlOB16mZbomDPd82Fy+Qr+GjJ2Zme
# 5opC+COLPLzYPqZ9u4rdT7kJ0/yeIU1KIHVR4Kkcex7ED6BZZta0FzPcC2ITlQXw
# NXlfXirBqNyUq/4ziD8coeZswLpEb+CHG4sCvhEYg6dRXOhhsLBqSHnVHUpEB74X
# ZO3oQtfa6JNejc+o40GtH9ocj/ejwLRCIEypXG4OzRQmPfrl+rLLsrL62zKaNk9h
# Ag+PDpGCdFr6g7cchfuYoJ+oLeIrm+xMb8hmLKGoWJDdwaXIANViHKSGNdsRCd1j
# FMkWzPk5gFTP9Mj4Y4V3uusGOJ8hxWmsD9RFj8NdO0BKrkgdnO2Ki8rswrkqIGj5
# tcW4iBOEgHO0GsAxOgayJpp5qFx5/OGr58xM4Vzb5h5fxTZHhJYFh09C55mkBrdJ
# ookKdWnpkvcnsLrCW+bVvs5ebRxzcVjSCJmYCdwLvEyaCjBXDOpbOyO1zAcdAgMB
# AAGjUzBRMB0GA1UdDgQWBBS24QYUkdZxaK/oJn6rQ8Bw1vXI1jAfBgNVHSMEGDAW
# gBS24QYUkdZxaK/oJn6rQ8Bw1vXI1jAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3
# DQEBCwUAA4ICAQAW/jOx7oYAmJ855QY0BV9TN1HZffYlfEndqyRwUZIWZpSV+qlv
# lFNISdjO+Ukxkf8KfTGkhQwPBwVOdrkvoyJwym7j8x8Ep0gsO42XOLuH3fvE6FUE
# goos4yEnbE+BYU5RRpjSu7rGKOfj2Nerjx6hwYySyGaPumPQuRWp2HcUTxP9Q589
# TIuZ2LnX5nVLnCb5+j6alAEmoBQNgKgK+566X7DNxyYKYOgIgRwS04mWlaAUsrjj
# ZZDhC9a14Y3CGliI/O+4y3bdkhy+6AY7wNNjPVeEeBywcFi2lItIU0UG7a/6LzCH
# RhwvYVXFLaj2JOlRwWXc21E9CTWlMMXyGmn82F1kcdWT5AdvV4CksvBmN3WlBdrs
# U5YaL6c2xWznC871R0eY3i9XRaUrt+WjhhAj1BzpVJu2iFJ/ljeUMpi6jR2TJ2pg
# gkuHt0JJFz5CJSKlXURP+jbjZu/3oaBWs+wEnbxK7KLMAWulWg9v/C9ecXZIso4Z
# EHy+ng4IKAohygww+K4Tiln/2h1TYXxJ9GsyFGRRBBoTbmvMhW2I9NH0fDIsCAGZ
# fcwLkM56kzPT2YcrAQRqoM/vNVUmCsl83kBeFCIWQzmMBNto0gclwpkO96nt3Lng
# Ln4/Tfy6yj/wmQ2oFTF3pqtaG3/lTUPtv+tNV0ebMX40F6wsN2VU9/ToyQ==
# -----END CERTIFICATE-----
rm /cert-ca.aws.pem*
#wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
#VERIFICATION_RESULT=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
#echo $VERIFICATION_RESULT
## get cert-ca-aws.pem file
wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem

## check certification
#openssl verify -CAfile cert-ca-aws.pem cert.pem
##output:
#cert.pem: OK
#cat cert.pem
#cat cert-ca-aws.pem
#openssl verify -CAfile cert-ca-aws.pem cert.pem
ls cert.pem
ls cert-ca.aws.pem
ls cert-ca.aws.pem.1
## insert openssl result to $VERIFICATION_RESULT
VERIFICATION_RESULT=$(openssl verify -CAfile cert-ca-aws.pem cert.pem)
echo $VERIFICATION_RESULT
## check if $VERIFICATION_RESULT result is correct
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi



## encrypt the generated master-key secret with the server certificate:
openssl rand -base64 32 > masterKey.txt

MASTER_KEY=$(openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0)

## insert encryptedSampleMessage into encSampleMsg.txt file
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt

# the content of encryptedSampleMessage is stored in a file called encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
# file encSampleMsgReady.txt is ready now to be used in "openssl enc...." command


## encrypt the generated master-key secret with the server certificate:
DECRYPTED_SAMPLE_MESSAGE=$(openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt)

## check response
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi


