/bin/bash

mkdir secretDir/
touch secretDir/.secret
chmod 600 ./secretDir/.secret
rm -r ./maliciousFiles
rm important.link
touch 4.txt
ln -s ./4.txt important.link
chmod +x ./yourSolution.sh
./yourSolution.sh ##cat ./CONTENT_TO_HASH | xargs | md5sum > secretDir/.secret
