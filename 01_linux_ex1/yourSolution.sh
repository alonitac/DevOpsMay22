#!/bin/bash
wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
mkdir src/secretDir
touch src/secretDir/.secret
chmod 600 src/secretDir/.secret
rm -r src/maliciousFiles/
rm src/important.link
cd src/
/bin/bash generateSecret.sh