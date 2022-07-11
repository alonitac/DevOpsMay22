814c5723c21e7e90a3eae36c8df3c513  -

Create Directory secretDir
mkdir secretDir
Delete Directory maliciousFiles
rm -rf maliciousFiles
Create file .secret in secretDir
touch secretDir/.secret
cd secretDir/
change permission for .secret file
chmod 600 .secret
cd ..
Unlink important.link
unlink important.link
Executing generateSecret.sh file
/bin/bash  generateSecret.sh
Done! Your secret was stored in secretDir/.secret
cd secretDir/
read the .secret Data
cat .secret
814c5723c21e7e90a3eae36c8df3c513  -



