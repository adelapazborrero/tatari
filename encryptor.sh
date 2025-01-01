#!/bin/bash
#  ______   ______     ______     ______   ______     ______     __  __     ______    
# /\__  _\ /\  __ \   /\  == \   /\__  _\ /\  __ \   /\  == \   /\ \/\ \   /\  ___\   
# \/_/\ \/ \ \  __ \  \ \  __<   \/_/\ \/ \ \  __ \  \ \  __<   \ \ \_\ \  \ \___  \  
#    \ \_\  \ \_\ \_\  \ \_\ \_\    \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_____\  \/\_____\ 
#     \/_/   \/_/\/_/   \/_/ /_/     \/_/   \/_/\/_/   \/_/ /_/   \/_____/   \/_____/ 
#                                                                                    
#  ---------------------------
# |   Developed by typ0@bol   |    
#  ---------------------------
#
# Generate RSA private and public keys if non existant
# openssl genrsa -out private_key.pem 2048 && openssl rsa -in private_key.pem -pubout -out public_key.pem

PUBLIC_KEY="-----BEGIN PUBLIC KEY-----
<Content of your public key>
-----END PUBLIC KEY-----"

# Check if a command argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 '<command>'"
    exit 1
fi

COMMAND="$1"
MY_AES_KEY=$(openssl rand -base64 32)
COMMAND_OUTPUT=$(eval "$COMMAND")
AES_ENCRYPTED_ENV_OUTPUT=$(echo -n "$COMMAND_OUTPUT" | openssl enc -aes-256-cbc -salt -pass pass:$MY_AES_KEY -pbkdf2 | base64 -w 0)
RSA_ENCRYPTED_AES_KEY=$(echo -n "$MY_AES_KEY" | openssl pkeyutl -encrypt -inkey <(echo "$PUBLIC_KEY") -pubin | base64 -w 0)
echo "\"$RSA_ENCRYPTED_AES_KEY\" \"$AES_ENCRYPTED_ENV_OUTPUT\""
