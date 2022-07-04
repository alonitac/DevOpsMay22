#!/bin/bash
cd src
mkdir secertDir
cd secretDir
touch .secret
chmod 777 .secret
chmod go-rw .secret
cd ..
rm - r  maliciousFiles
rm important.link
/bin/bash generateSecret.sh