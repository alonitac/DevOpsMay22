#!/bin/bash
# Ofek Yanin solution ;-)
srcPath="$PWD/src"

wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvzf secretGenerator.tar.gz
cd $srcPath
mkdir secretDir
rm -rf maliciousFiles
touch secretDir/.secret
chmod 600 secretDir/.secret
rm important.link
ln -s "$srcPath/secretDir/.secret" important.link
chmod +x generateSecret.sh
./generateSecret.sh


