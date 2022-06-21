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
#Checks if secretDir is already exists else create a new dir.
  echo "Creating dir SecretDir in src directory" && sleep 2
  mkdir secretDir

# Checks if maliciousFiles dir is exists and remove it else show message.
  echo "Deleting MaliciousFiles directory from the src directory" && sleep 2
  rm -rf maliciousFiles

#Verify changes
ls -la

# Creating .secret file in secretDir
  echo -e "Creating .secret file in the src/secretDir dir " && sleep 2
  cd secretDir
  sudo touch .secret

# Checks if the .secret file permission is not 600 and add R and W to the other users
OCTAL_PERMISSIONS=$(stat -c "%a" .secret)
if [ "$OCTAL_PERMISSIONS" != "600" ]; then
  echo "changing file .secret permissions to read and write" && sleep 2
  sudo chmod 600 .secret
  cd ..
fi

# Creating file someFileIsLinkingToMe.BeAware.
echo "New file creation : someFileIsLinkingToMe.BeAware"
touch someFileIsLinkingToMe.BeAware

# unlink and link important file to the file above
if [ -L 'important.link' ] && [ ! -e 'important.link' ]; then
  echo "Remove the linking from important file a redirect for the someFileIsLinkingToMe.BeAware file" && sleep 2
  sudo unlink important.link
  ln -s someFileIsLinkingToMe.BeAware important.link -v
fi

sudo cat CONTENT_TO_HASH | xargs | md5sum > secretDir/.secret && echo "Done! Your secret was stored in secretDir/.secret"