#!/bin/bash
mkdir secretDir
rm -rf maliciousFiles
touch secretDir/.secret
chmod 600 secretDir/.secret
unlink important.link
chmod 777 generateSecret.sh
./generateSecret.sh