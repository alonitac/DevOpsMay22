#/bin/bash/secret
mkdir secretDir
 cd  secretDir
touch  .secret
chmod 600 .secret
cd ..
rm  -r maliciousFiles/
find -xtype  l -delete
/bin/bash generateSecret.sh
