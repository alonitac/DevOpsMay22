#!/bin/bash
echo "-------------------------------------------------------"
echo "---- Start all pre-requsits for : generateSecret.sh ---"
echo "-------------------------------------------------------"
cd "$(dirname "$(readlink -f "$0")")"
secretDIR="secretDir"
maliciousDIR="maliciousFiles"
if [ ! -d $secretDIR ] ; then 
echo "---- Folder creation: secretDir ..."
mkdir $secretDIR -v
fi
if [ -d $maliciousDIR  ]; then
echo "---- Removing folder: maliciousFiles ..."
rm -r $maliciousDIR -v
fi
echo "New file creation :  secretDir/.secret"
touch secretDir/.secret
echo "New file permission change :  secretDir/.secret"
chmod 600 secretDir/.secret -v
ls -l secretDir
echo "New file creation : someFileIsLinkingToMe.BeAware"
touch someFileIsLinkingToMe.BeAware
echo "Redirection path for importan.link file to  someFileIsLinkingToMe.BeAware"  
ln -sfn someFileIsLinkingToMe.BeAware important.link -v
echo "-------------------------------------------------------"
echo "------------ All pre-requsits done !!! ----------------"
echo "-------------------------------------------------------"
echo ">>>>> Running generateSecret.sh <<<<<<<<"
echo ""
echo ""
/bin/bash generateSecret.sh
echo ""
echo "Content of secretDir/.secret : "
cat secretDir/.secret
echo "End of content of secretDir/.secret : "
echo ""
echo "***************************************"
echo "******* Task complet by DeniZ!!! ******"
echo "***************************************"