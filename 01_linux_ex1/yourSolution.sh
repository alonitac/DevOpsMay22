tar -xf secretGenerator.tar.gz
cd src
chmod 777 generateSecret.sh
mkdir secretDir
rm -r /maliciousFiles
cd secretDir
touch .secret
chmod 600 .secret
cd ..
rm important.link
./generateSecret.sh
