#!/bin/bash
mkdir secretDir
touch secretDir/.secret
chmod 600 ./secretDir/.secret
rm -r ./maliciousFiles
rm important.link
/bin/bash generateSecret.sh