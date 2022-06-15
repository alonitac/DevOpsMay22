#!/bin/bash
wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
cat src/generateSecret.sh
rm -r src/maliciousFiles
rm src/important.link
mkdir src/secretDir
chmod 777 src/secretDir
umask 066
cd src/secretDir
touch .secret
cd ..
chmod 777 generateSecret.sh
sudo ./generateSecret.sh
