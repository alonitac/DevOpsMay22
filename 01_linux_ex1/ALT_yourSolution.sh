##Create target download folder+cd
                            echo create work folder "thesecret"
                                     					    mkdir ~/thesecret
                            echo entering thesecret folder
                                     					    cd thesecret
##Wget tar package
                            echo downloading package
                                                            wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
 	                        echo hold on to your pants..
                            sleep 1

##Exract tar package locally
                            echo Extracting...
                 	             	                        tar -vzxf secretGenerator.tar.gz
							sleep 2
                            echo Files extracted succesfuly
##Commands to revel my secret
            #Create target folder + target file + permissions
                            echo create secretDir folder
 		   				    echo Step 1 entering src folder
                                      					    cd src
                            echo Step 2 Creating secretDir folder
 	                                    				    mkdir secretDir
                            echo Step 3 entering secretDir folder
 		                                    			    cd secretDir
                            sleep 1
							echo Perfect
                            echo create .secret file
                                   						    touch .secret
                            sleep 1
							echo excellent!!!
                            echo provide read write permissions to .secret file
                                                            chmod 600 ~/thesecret/src/secretDir/.secret
                            echo Permissions granted
							echo leaving src folder
															cd ..
 		                    sleep 1
            #Dealing with malicious & links
                            echo OH NO... Someone trying to hack me...
							echo Deleting suspicious content
                                   						    rm -r maliciousFiles
                            echo Unlink the junk
                                   						    find -xtype l -delete
 #Execute bash script
                            echo GENERATING MY SECRET - KEEP IT BETWEEN US
                                   						    /bin/bash generateSecret.sh
                            echo dont give up now you almost there.....
                            sleep 1

 #delete unnecessary content from src folder
                            echo clean up your mess
                            echo deleting files
                                                            rm -r CONTENT_TO_HASH
                                                            rm -r generateSecret.sh
                                                            rm -r yourSolution.sh

 	        #revele the damn secret
                            echo MY SECRET IS:
 	                                   					    cat secretDir/.secret
                            echo Thank you for flying -=RoyOps=-
