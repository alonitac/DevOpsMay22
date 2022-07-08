tar -zxvf secretGenerator.tar.gz
#goes to check if any  maliciousFiles are existing
cd src/
chmod +x generateSecret.sh
#need to make a directory for secret file
mkdir secretDir
touch secretDir/.secret
#creates a file . secret
chmod 764 secretDir/.secret
#gives the file permissions
chmod go-rw secretDir/.secret

rm maliciousFiles/*

rmdir maliciousFiles/
rm important.link
./generateSecret.sh
