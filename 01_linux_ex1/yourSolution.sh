#!/bin/bash

#Get WorkDir
cd "$(dirname "$(readlink -f "$0")")" || exit

#Set Dirctories names
secretDIR="secretDir"
maliciousDIR="maliciousFiles"

#Check if secretDir exists
if [ ! -d $secretDIR ] ; then 
echo "---- Folder creation: secretDir ..."
mkdir $secretDIR -v
fi

#Check if maliciousDir exists
if [ -d $maliciousDIR  ]; then
echo "---- Removing folder: maliciousFiles ..."
rm -r $maliciousDIR -v
fi

#create new file .secret
echo "New file creation :  secretDir/.secret"
touch secretDir/.secret
#set permissions to file
echo "New file permission change :  secretDir/.secret"
chmod 600 secretDir/.secret -v
ls -l secretDir

#create and link important.link to maliciousDIR
echo "New file creation : someFileIsLinkingToMe.BeAware"
touch someFileIsLinkingToMe.BeAware
echo "Redirection path for importan.link file to  someFileIsLinkingToMe.BeAware"  
ln -sfn someFileIsLinkingToMe.BeAware important.link -v

#Get secret by running generateSecret.sh
echo ">>>>> Running generateSecret.sh <<<<<<<<"
/bin/bash generateSecret.sh
echo "Content of secretDir/.secret : "
cat secretDir/.secret
