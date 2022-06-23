# Docs reference https://www.openssl.org/docs/manmaster/man1/openssl-enc.html

# -e              Encrypt file
# -aes-256-cbc    The algo name
# -pbkdf2         Use PBKDF2 algorithm to generate a key from the password
# -k              User password
# -in             The input file
# -out            The output file

ENCRYPTION_PASSWORD='vv7:K0r|E[PC!JM'
openssl enc -e -aes-256-cbc -pbkdf2 -k "$ENCRYPTION_PASSWORD" -in secret -out encrypted_secret