# -d              Decrypt file
# -aes-256-cbc    The symmetric encryption algo name
# -k              User password
# -in             The input file
# -out            The output file

ENCRYPTION_PASSWORD='vv7:K0r|E[PC!JM'
openssl enc -d -aes-256-cbc -pbkdf2 -k "$ENCRYPTION_PASSWORD" -in encrypted_secret -out decrypted_secret