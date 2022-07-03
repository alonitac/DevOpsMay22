#!/bin/bash
wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
rm -r src/maliciousFiles/
rm src/important.link
mkdir src/secretDir
chmod 700 src/secretDir
cd src/secretDir
touch .secret
chmod 600 .secret
cd ..
chmod 700 generateSecret.sh
/bin/bash generateSecret.sh
