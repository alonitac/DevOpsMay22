#!/bin/bash

mkdir secretDir
cd secretDir
touch .secret
chmod 777 .secret
chmod go-rw .secret
cd ..
rm - r  maliciousFiles
rm important.link
/bin/bash generateSecret.sh