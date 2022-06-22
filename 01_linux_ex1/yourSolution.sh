

wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
ls -l # checks the name of the file that i got
tar xvf secretGenerator.tar.gz
#goes to check if any  maliciousFiles are existing
rm -r  src/maliciousFiles
- # rm -r command can remove a dir
mkdir src/secretDir
#now i need to give the directory permissions
chmod 764 src/secretDir
umask 066 # in order to give the files that i create permissions
cd src/secretDir

 # now needed to create a file  ./secret
