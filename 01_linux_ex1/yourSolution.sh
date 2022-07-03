chmod 777 generateSecret.sh
mkdir secretDir
cd secretDir
touch .secret
chmod 600 .secret
cd ..
rm -r maliciousFiles
rm important.link
/bin/bash generateSecret.sh
