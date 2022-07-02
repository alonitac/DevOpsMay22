#!/bin/bash

tar -xvf secretGenerator.tar.gz
cd src/
chmod +x generateSecret.sh
mkdir secretDir
rm -rf maliciousFiles/
touch secretDir/.secret
chmod 600 secretDir/.secret
unlink important.link
./generateSecret.sh