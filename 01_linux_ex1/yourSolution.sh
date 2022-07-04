wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
cd src/
rm -r important.link && rm -r maliciousFiles/
mkdir secretDir
cd secretDir
touch .secret
chmod 777 .secret
cd ..
/bin/bash generateSecret.sh
cd secretDir/
cat .secret