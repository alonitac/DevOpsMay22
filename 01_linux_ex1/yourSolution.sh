wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
mkdir secertDir
cd secretDir
touch.secret
chmod  777 .secret
chmod go-rw .secret
cd ..
rm - r  maliciousFiles
rm important.link
/bin/bash generateSecret.sh