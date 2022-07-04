#!/bin/bash
mkdir src/secretDir
touch src/secretDir/.secret
chmod 600 src/secretDir/.secret
cd src/ || exit
rm -r maliciousFiles/
rm important.link
/bin/bash generateSecret.sh