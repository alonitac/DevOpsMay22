# Linux ex-2
Due date: 25/07/2022 23:59
 
## Preliminaries

1. Open [our shared git repo](https://github.com/alonitac/DevOpsMay22) in PyCharm and pull the repository in branch **main** to get an up-to-date version of the repo.
2. Create your own git branch for this exercise according to  `linux_ex2/<alias>` (replace `<alias>` by your name, e.g. linux_ex2/alonit).

## linux_ex2/lianops

### TLS communication

**70 points**


![Alice-Bob-Eve](img/alice-bob-eve.png)

As you know, the communication in HTTP protocol is insecure, and since Eve is listening on the channel between you (Alice) and the web server (Bob), you are required to create a secure channel. 
This is exactly what SSL/TLS does. The process of establishing a secure SSL/TLS connection involves several steps. SSL/TLS security protocols use a combination of _asymmetric_ and _symmetric_ encryption:

##### Step 1 - Client Hello (Client -> Server). 

First, the client sends a _Client Hello_ to the server.

##### Step 2 - Server Hello (Server -> Client)

The server replies with a _Server Hello_. A Server Hello includes the following information:

- **Server Version** - the TLS version the server uses
- **Session ID** - it is used to resume the current communication session between the server and the client
- **Server digital certificate** - the certificate contains some details about the server, as well as a public key with which the client can encrypt messages to the server. The certificate itself is signed by Certificate Authority (CA).


##### Step 3 - Server Certificate Verification 

As seen above, Eve is "sitting" on the channel between Alice and Bob. So what's stopping her from impersonating Bob, and once Alice sends _Client Hello_, she is replied by a fake _Server Hello_ message with "certificate" issued by Eve itself. In such case, Alice would believe that the certificate belongs to Bob, encrypt messages to Bob using the certificate, without knowing that Eve could decrypt the messages.

Here the CA comes into the picture. CA is an entity (e.g. Amazon Web Services, Microsoft etc...) trusted by both sides (client and server) that issues and signs digital certificates, so the ownership of a public key can be easily verified.

In this step the client verifies the server's digital certificate.


##### Step 4 - Client-Server master-key exchange

Cert was verified successfully? great we can move on...

Now, the client and the server should agree on a _symmetric key_ (called _master key_) with which they will communicate during the session. 
The client generates a 32-bytes random master-key, encrypts it using the server's certificate and sends the encrypted message in the channel. 

In addition to the encrypted master-key, the client sends a sample message to verify that the symmetric key encryption works.    

##### Step 5 - Server verification message 

The server decrypts the encrypted master-key. From now on, every message between both sides will be symmetrically encrypted by the master-key. 
The server encrypts the sample message and sends it to the client. 

##### Step 6 - Client verification message

The Client verifies that the sample message was encrypted successfully.


#### Let's get started...

You are given an HTTP web server with hostname `http://16.16.53.16:8080`. 
Your goal is to perform the above steps using BASH commands, and establish a secure channel with the server. 

Please work in Ubuntu terminal, not from PyCharm. Below are some helpful instructions you may utilize in each step. Eventually, all your code should be written in `06_linux_ex2/tlsHandshake.sh`, committed and pushed to GitHub. 

Use `curl` to send the following _Client Hello_ HTTP request to the server:
```
POST /clienthello
{
  "clientVersion": "3.2",
  "message": "Client Hello"
}
```
_POST_ is the request type, _/clienthello_ is the endpoint, and the json is the body.  

_Server Hello_ response will be in the form:
```json
{
  "serverVersion": "3.2",
  "sessionID": "$(tail -n 1 info.txt)",
  "serverCert": "wget https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem
VERIFICATION_RESULT=$(openssl verify -CAfile cert-ca-aws.pem cert.pem"
}
```
The response is in json format. You may want to keep the sessionID in a variable called `SESSION_ID` for later usage,
and save the server cert in a file called `cert.pem`.
Use the command `jq -r '.<key>'` to parse and save specific keys from the JSON response (replace `<key>` by _serverVersion_, _sessionID_ or _serverCert_ according to your needs). You should use pipe (`|`) in order to pass the HTTP json response as an input to `jq`. Don't have `jq` on your Ubuntu? you know how to install it...

Assuming the server certificate was stored in `cert.pem` file. You can verify the certificate by:
```shell
openssl verify -CAfile cert-ca-aws.pem cert.pem
```
while `cert-ca-aws.pem` is a file belonging to the Certificate Authority (in our case Amazon Web Services) who issued and signed the server cert. You can safely download it from **https://devops-may22.s3.eu-north-1.amazonaws.com/cert-ca-aws.pem** (wget...)

Upon a valid certificate validation, the following output will be printed to stdout:
if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
cert.pem: OK
```

In your tlsHandshake.sh file, use this snippet to exit the program if the certificate validation failed. Make sure you understand the code.
```shell
VERIFICATION_RESULT=$( openssl verify -CAfile cert-ca-aws.pem cert.pem )

if [ "$VERIFICATION_RESULT" != "cert.pem: OK" ]; then
  echo "Server Certificate is invalid."
  exit 1
fi
```

Given a valid cert, generate a 32 random bytes base64 string (use `openssl rand`) and save it to `masterKey.txt` text file.

Got tired? refresh yourself with some [interesting reading](https://www.bleepingcomputer.com/news/security/russia-creates-its-own-tls-certificate-authority-to-bypass-sanctions/amp/).  

This line can help you encrypt the generated master-key secret with the server certificate:
```shell
openssl smime -encrypt -aes-256-cbc -in masterKey.txt -outform DER cert.pem | base64 -w 0
```

Now, `curl` again an HTTP POST request to the server endpoint `/keyexchange`, with the following body
```
POST /keyexchange
{
    "sessionID": "'$SESSION_ID'",
    "masterKey": "'$MASTER_KEY'",
    "sampleMessage": "Hi server, please encrypt me and send to client!"
}
```

Note that `$SESSION_ID` is a BASH variable containing the session ID you've got from the server's hello response, you need to create this variable once you have the sessions ID from the server. Also, `$MASTER_KEY` is your **encrypted** master key, again, you need to create this variable.

The response for the above request would be in the form:
curl -s --header "Content-Type: application/json" -d '{"sessionID": "'"$SESSION_ID"'", "masterKey": "'"$MASTER_KEY"'", "sampleMessage": "Hi server, please encrypt me and send to client!"}' http://16.16.53.16:8080/keyexchange | jq -r '.encryptedSampleMessage' > encSampleMsg.txt
cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt
openssl enc -d -aes-256-cbc -pbkdf2  -kfile masterKey.txt -in encSampleMsgReady.txt -out decSampleMsgReady.txt
DECRYPTED_SAMPLE_MESSAGE=$(tail decSampleMsgReady.txt)
{
  "sessionID": ".....",
  "encryptedSampleMessage": "....."
}
```
All you have to do now is to decrypt the sample message and verify that it's equal to the original sample message. 
This will indicate that the server uses successfully the master key.
Please note that the _encryptedSampleMessage_ is encoded in base64, before you decrypt it, encode it to binary, as following:
```shell
# the content of encryptedSampleMessage is stored in a file called encSampleMsg.txt

cat encSampleMsg.txt | base64 -d > encSampleMsgReady.txt

# file encSampleMsgReady.txt is ready now to be used in "openssl enc...." command 
```
Recall the demo in `01_encryption` directory in our shared repo to see how to decrypt a message. Again, you should exit the program upon an invalid decryption. Do it by:
```shell
if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi
```

**Well Done! you've manually implemented a secure communication over HTTP :-)**

In real life we have TLS that does so for us, and it's quite similar to what you've done.


### if [ "$DECRYPTED_SAMPLE_MESSAGE" != "Hi server, please encrypt me and send to client!" ]; then
  echo "Server symmetric encryption using the exchanged master-key has failed."
  exit 1
else
  echo "Client-Server TLS handshake has been completed successfully"
fi

**20-25 points**

Write your answers in the `06_linux_ex2/README` file.

**(Q1)** A user started a process and logged out from the terminal. Which command he used if the process still running in the background:

* nokill
* nohup
* nofg
* bg

**(Q2)** The `kill` command always terminates a process.

* True
* False

**(Q3)** Which command could be used to know how many processes are running in the background terminal session?

* process
* jobs
* work
* list

**(Q4)** Given a terminal session with long process running in it, how will you ask this process to terminate?

* CTRL+z
* CTRL+c
* CTRL+l
* CTRL+c twice

**(Q5)** Given a terminal session with long process running in it, how will you ask this process the stop?

* CTRL+z
* CTRL+c
* CTRL+l
* CTRL+c twice

**(Q6)** How would you run the `sleep 10` command as a foreground process?

* fg sleep 10
* sleep 10 &
* foreground sleep 10
* sleep 10

Given the following output

![ps-output](img/ps-output.png)

**(Q7)** Which of the following command would deliver a SIGTERM to the `xscreensaver` process?

* kill TERM xscreensaver
* kill 4846
* kill xscreensaver
* kill -9 4846
* None of the above

**(Q8)** Which of the following would deliver a SIGKILL to the `xscreensaver` command?

* kill -9 4846
* kill xscreensaver
* kill -KILL xscreensaver
* kill -15 4846
* None of the above

**(Q9)** Which of the following would send a SIGCHLD (signal number 17) to the `ssh-agent` process?

* kill -CHLD ssh-agent
* kill -17 ssh-agent
* kill -CHLD 4828
* All of the above
* A and C only


**(Q10)** Which key pressed within the `top` command allows the user to send a signal to a process?

* s
* z
* t
* k
* None of the above


**(Q11 - easy 5 points bonus)** Open a new terminal session and type the command `python`. Then send a SIGINT signal using your keyboard. What best describes how the python process responds to the SIGINT signal? (you can exit this process by typing `exit()` in the python console)

* The program ignores the SIGINT signal.
* The program has implemented a custom signal handler for the SIGINT signal.
* The program implements the kernel default signal handler for the SIGINT signal, which is to terminate the process.
* The program implements the kernel default signal handler for the SIGINT signal, which is to stop (suspend) the process.
* None of the above


### Process states

**20 points** 

Generally speaking, in Linux system, two different processes cannot write to the same file concurrently (exactly at the same moment). Each process needs to obtain an exclusive write lock for the file. That implies that all the other processes who willing to write to this file will have to wait while one process is writing to it. The more I/O intensive processes you have, the longer the wait time. 

In this question we will create processes which are competing on the same resource (same file), and see how some of them are changing their state from Running to Waiting. 

Use `nano` to create the following script, store it as `~/write_to_file_sequentially.sh`, and make it
executable.

```shell
#!/bin/bash
for i in $(seq 1000); do
  echo "hello world" > overloaded_file
done
```

This script writes the string "hello world" to a file called "overloaded_file". It does so 1000 times **sequentially**, and so will never be competing for access the file.
Because we need multiple processes competing over the same resource, create the following script as well:

```shell
#!/bin/bash
for i in $(seq 1000); do
  ./write_to_file_sequentially.sh &
done
```

Name it `~/multi_process_file_writing.sh`. Make sure you understand what this script does. 

In another terminal, run `top`. In a one more separate terminal, be ready to run the command `ps aux`. 
To summarize: 

- Terminal 1 will be running `multi_process_file_writing.sh`.
- Terminal 2 will be running `top`
- Terminal 3 will take a snapshot of `ps aux`

Now that everything is ready, run `./multi_process_file_writing.sh` and observe the terminal running the `top` command. While you see the `multi_process_file_writing` process in top, take the snapshot.

From `ps` [man page](https://man7.org/linux/man-pages/man1/ps.1.html#PROCESS_STATE_CODES), read what each process state code means. 
Explore `ps -aux` output and **take a screenshot** which indicates that some processes are waiting (sleeping due to IO operation), and some others are running.
While you'll find many processes in a waiting state, it may be hard to catch a process in a running state... try to execute `ps aux` again until you'll fine one. 
You may also find `ps aux | grep "   R    "` useful. Commit and push the screenshot file under `06_linux_ex2/ps_out.png` (or `.jpg`).

# Good Luck

Don't hesitate to ask any questions