#-=RoyOps-=#-----------#/bin/bash generateSecret.sh-----------

 #Create target download folder+cd
                             echo create work folder
                                                    echo
						                                        mkdir ~/thesecret
					                                     	    echo
				                                    		    cd thesecret
 #Wget tar package
                             echo downloading package
                                                    echo
						                                        wget https://devops-may22.s3.eu-north-1.amazonaws.com/secretGenerator.tar.gz
		                         echo hold on to your pants..
                             sleep 1

 #Exract tar package locally
                             echo extracting...
                                                    echo
						                                        tar -vzxf secretGenerator.tar.gz
               		           echo finished extracting files
			                       sleep 5
 #Commands to revel my secret
            #Create target folder + target file + permissions
                             echo create secretDir folder
						                                        echo
						                                        cd src
                                         	          echo
						                                        mkdir secretDir
						                                        echo
						                                        cd secretDir
                             sleep 1
      			                 echo create .secret file
						                                        echo
						                                        touch .secret
			                       sleep 1
 			                       echo provide read write permissions to .secret file
                                                    echo
						                                        chmod 600 ~/thesecret/src/secretDir/.secret
						                                        echo
						                                        cd ..
		                         sleep 1
            #Dealing with malicious & links
                                                    echo
						                                        rm -r maliciousFiles
                                                    echo
						                                        find -xtype l -delete
  #Final - Execute bash script
                                                    echo
						                                        /bin/bash generateSecret.sh
                             echo dont give up now you almost there.....
                             sleep 1
		#revele the damn secret
		                       		                      echo
						                                        cat secretDir/.secret

###RoyOps magic script






