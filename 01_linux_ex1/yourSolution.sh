tar -xvf secretGenerator.tar.gz
cd src
mkdir secretDir
rm -r maliciousFiles
touch secretDir/.secret
chmod 600 secretDir/.secret
unlink important.link
/bin/bash generateSecret.sh