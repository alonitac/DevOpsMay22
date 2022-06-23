# Encryption with OpenSSL

All demos should be run on Linux system. 

## Symmetric encryption

Given a file `secret` to encrypt, run `encrypt.sh` and explore the generated encrypted content. To decrypt the content, run `decrypt.sh`.


## Asymmetric encryption

First generate a private-public key pair by running `generate.sh` (make sure you don't override important existing keys!!!). 
Then, use `encrypt.sh` and `decrypt.sh` as above. 