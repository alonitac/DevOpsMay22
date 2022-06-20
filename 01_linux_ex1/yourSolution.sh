wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
tar -xvf secretGenerator.tar.gz
mkdir secretDir
touch .secret
chmod 777 src/secretDir/.secret
rm -r maliciousFiles/
rm important.link
/bin/bash generateSecret.sh