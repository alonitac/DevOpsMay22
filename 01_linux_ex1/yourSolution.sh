mkdir secretDir
touch secretDir/.secret
chmod 600 ./secretDir/.secret
rm -r ./maliciousFiles
rm important.link
