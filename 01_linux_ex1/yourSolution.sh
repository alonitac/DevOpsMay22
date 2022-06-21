echo "
███████╗███████╗ ██████╗██████╗ ███████╗████████╗     ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ████████╗ ██████╗ ██████╗
██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝╚══██╔══╝    ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
███████╗█████╗  ██║     ██████╔╝█████╗     ██║       ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║   ██║   ██║   ██║██████╔╝
╚════██║██╔══╝  ██║     ██╔══██╗██╔══╝     ██║       ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║   ██║   ██║   ██║██╔══██╗
███████║███████╗╚██████╗██║  ██║███████╗   ██║       ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║   ██║   ╚██████╔╝██║  ██║
╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝   ╚═╝        ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
"
echo "
╔═╗┬─┐┌─┐┌─┐┌┬┐┌─┐┌┬┐  ┌┐ ┬ ┬  ╔═╗┬ ┬┌─┐┬─┐┌─┐┌┐┌  ╦  ┌─┐┬  ┬┬
║  ├┬┘├┤ ├─┤ │ ├┤  ││  ├┴┐└┬┘  ╚═╗├─┤├─┤├┬┘│ ││││  ║  ├┤ └┐┌┘│
╚═╝┴└─└─┘┴ ┴ ┴ └─┘─┴┘  └─┘ ┴   ╚═╝┴ ┴┴ ┴┴└─└─┘┘└┘  ╩═╝└─┘ └┘ ┴
"
read -p "Press enter to start the program"

#Checks if secretDir is already exists else create a new dir.
if [ -d "src/secretDir" ]; then
  echo "The directory secretDir is already exists" && sleep 2
else
  echo "Creating dir SecretDir in src dir" && sleep 2
  mkdir secretDir/ -v
fi

# Checks if maliciousFiles dir is exists and remove it else show message.
if [ -d "glemaliciousFiles" ]; then
  echo "Deleting MaliciousFiles dir from the src dir" && sleep 2
  rm -rf src/maliciousFiles -v
else
       echo " malicius files is already deleted " && sleep 2
fi

ls -la
# Creating .secret file in secretDir
  echo -e "Creating .secret file in the src/secretDir dir " && sleep 2
  touch secretDir/.secret -v

# Checks if the .secret file permission is not 600 and add R and W to the other users
OCTAL_PERMISSIONS=$(stat -c "%a" src/secretDir/.secret)
if [ "$OCTAL_PERMISSIONS" != "600" ]; then
  echo "changing file .secret permissions to read and write only for the other users" && sleep 2
  sudo chmod 600 src/secretDir/.secret
fi

# Creating file someFileIsLinkingToMe.BeAware.
echo "New file creation : someFileIsLinkingToMe.BeAware"
touch someFileIsLinkingToMe.BeAware

# unlink and link important file to the file above
if [ -L 'src/important.link' ] && [ ! -e 'src/important.link' ]; then
  echo "Remove the linking from important file a redirect for the someFileIsLinkingToMe.BeAware file" && sleep 2
  sudo unlink src/important.link
  ln -s someFileIsLinkingToMe.BeAware important.link -v
fi

sudo cat $HOME/src/CONTENT_TO_HASH | xargs | md5sum > src/secretDir/.secret && echo "Done! Your secret was stored in secretDir/.secret"