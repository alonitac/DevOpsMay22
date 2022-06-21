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

# Checks if src dir and secretGenerator file is not exists then download the tar file else send a message.
if [ ! -d "./src" ] && [ ! -f "./secretGenerator.tar.gz" ]; then
       echo -e "secretGenerator.tar.gz is missing\nDirectory Src is missing!\ndownloading and extracting the secretGenerator.tar.gz file"
        wget -P home/runner/ https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
        echo "-------Download complete-------" && sleep 2
else
        echo -e "SecretGenerator.tar.gz is already downloaded" && sleep 2
fi
# Checks if src dir already exists, remove the exisiting src and extract the content from the tar file else only extract the tar file.
if [ -d "src" ];
then
  echo -e "Src directory is alreade exists\nremove old dir and extracting content from the tar.gz file to the Home dir"
  sudo rm -rf /src
  tar -xf home/runner/secretGenerator.tar.gz
  echo "-------Extract complete-------" && sleep 2
else
  echo -e "SecretGenerator.tar.gz is already downloaded\nextracting the file content to Home dir"
  tar -xf home/runner/secretGenerator.tar.gz
  echo "-------Extract complete-------" && sleep 2
fi

#Checks if secretDir is already exists else create a new dir.
if [ -d "src/secretDir" ]; then
  echo "The directory secretDir is already exists" && sleep 2
else
  echo "Creating dir SecretDir in src dir" && sleep 2
  mkdir src/secretDir
fi
# Checks if maliciousFiles dir is exists and remove it else show message.
if [ -d "src/maliciousFiles" ]; then
  echo "Deleting MaliciousFiles dir from the src dir" && sleep 2
  sudo rm -rf src/maliciousFiles
else
       echo " malicius files is already deleted " && sleep 2
fi

# Checks if .secret file in the secretDir if not create the .secret file in this dir.
if [ ! -f "src/secretDir/.secret" ]; then
        echo -e "Creating .secret file in the src/secretDir dir " && sleep 2
  sudo touch src/secretDir/.secret
fi

# Checks if the .secret file permission is not 600 and add R and W to the other users
OCTAL_PERMISSIONS=$(stat -c "%a" src/secretDir/.secret)
if [ "$OCTAL_PERMISSIONS" != "600" ]; then
  echo "changing file .secret permissions to read and write only for the other users" && sleep 2
  sudo chmod 006 src/secretDir/.secret
fi

# practice file linking understanding
if [ -L 'src/important.link' ] && [ ! -e 'src/important.link' ]; then
  echo "Remove the linking from important file" && sleep 2
  sudo unlink src/important.link
fi

sudo cat ~/src/CONTENT_TO_HASH | xargs | md5sum > src/secretDir/.secret && echo "Done! Your secret was stored in secretDir/.secret"