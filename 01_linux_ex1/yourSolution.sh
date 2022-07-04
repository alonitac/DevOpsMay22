#!/bin/bash
mkdir secretDir
rm -r maliciousFiles/
rm important.link
cd secretDir/
touch .secret
chmod 600 .secret
cd ..
/bin/bash generateSecret.sh