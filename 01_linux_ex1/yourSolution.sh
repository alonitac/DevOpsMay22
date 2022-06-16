/bin/bash

mkdir secretDir/.secret
chmod 600 ./secretDir/.secret
rm -r ./maliciousFiles
rm important.link
touck 4.txt
ln -s ./4.txt important.link
./yourSolution.sh   ##cat ./CONTENT_TO_HASH | xargs | md5sum > secretDir/.secret