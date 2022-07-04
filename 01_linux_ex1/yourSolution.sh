rm -r important.link && rm -r maliciousFiles/
mkdir secretDir
cd secretDir
touch .secret
chmod 600 .secret
cd ..
/bin/bash generateSecret.sh
cd secretDir/
cat .secret