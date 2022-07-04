mkdir secretDir
cd maliciousFiles/
rm amIMaliciousOrNot.whoKnows
rm someFileIsLinkingToMe.BeAware
cd ..
rm -d maliciousFiles/
cd secretDir/
touch .secret
chmod 600 .secret
cd ..
unlink important.link
/bin/bash generateSecret.sh
