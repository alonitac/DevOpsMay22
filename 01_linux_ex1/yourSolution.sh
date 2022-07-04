
#goes to check if any  maliciousFiles are existing
rm -r  src/maliciousFiles
rm  src/important.link
- # rm -r command can remove a dir
mkdir src/secretDir
#now i need to give the directory permissions
chmod 764 src/secretDir
umask 066 # in order to give the files that i create permissions
cd src/secretDir
 # now needed to create a file  ./secret
touch .secret #
sudo ./generateSecret.sh

# all is left is to view the secret with a cat command.