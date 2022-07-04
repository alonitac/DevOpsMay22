#!/bin/bash
wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
mkdir src/secretDir
cd src/secretDir
touch .secret
chmod 600 .secret
rm -r src/maliciousFiles/
rm src/important.link
cd ..
/bin/bash generateSecret.sh
