#!/bin/bash

# Check if the correct number of arguments is passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <RSA_ENCRYPTED_AES_KEY> <AES_ENCRYPTED_ENV_OUTPUT>"
    exit 1
fi

# Set the arguments
PRIVATE_KEY_PATH="private_key.pem"
RSA_ENCRYPTED_AES_KEY="$1"
AES_ENCRYPTED_ENV_OUTPUT="$2"

# Decrypt the AES key using the RSA private key
MY_AES_KEY=$(echo -n "$RSA_ENCRYPTED_AES_KEY" | base64 -d | openssl pkeyutl -decrypt -inkey $PRIVATE_KEY_PATH)

# Decrypt the environment variables using the decrypted AES key
DECRYPTED_ENV=$(echo -n "$AES_ENCRYPTED_ENV_OUTPUT" | base64 -d | openssl enc -d -aes-256-cbc -pass pass:$MY_AES_KEY -pbkdf2)

# Output the decrypted environment variables
echo "Decrypted :"
echo "----------"
echo "$DECRYPTED_ENV"
