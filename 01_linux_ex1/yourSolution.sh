#!/bin/bash

mkdir secretDir
cd secretDir
touch .secret

cd ..
rm -r  maliciousFiles
rm important.link
chmod 600 .secret
/bin/bash generateSecret.sh