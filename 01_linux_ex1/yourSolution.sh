# /bin/bash generateSecret.sh - royops
mkdir secretDir
rm -r maliciousFiles/
touch secretDir/.secret
cd secretDir
chmod 600 .secret
cd ..
find -xtype l -delete
/bin/bash generateSecret.sh


