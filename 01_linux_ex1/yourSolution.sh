tar -xf secretGenerator.tar.gz

cd src

rm -fr maliciousFiles/

chmod 700 generateSecret.sh

rm important.link

mkdir secretDir

cd secretDir/

touch .secret

chmod 600 .secret

cd ..

./generateSecret.sh