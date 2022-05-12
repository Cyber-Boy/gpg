#!/bin/bash

echo "Do you want to create a new key or use an old one?"
read FLAG

KEY_INDEX=0
KEYS=()

if [[ $FLAG -eq 1 ]]
then
    #Take checks
    while [[ ! $NAME =~ ^[A-Z][a-z]+[\ \t][A-Z][a-z]+$ ]]; do
        echo "Enter Full Name: "
        read NAME
    done
    echo "Email Address: "
    read EMAIL
    echo "Comment: "
    read COMMENT
    echo "%no-protection" > genkey-batch
    echo "Key-Type: default" >> genkey-batch
    echo "Subkey-Type: default" >> genkey-batch
    echo "Name-Real: ${NAME}" >> genkey-batch
    echo "Name-Email: ${EMAIL}" >> genkey-batch
    echo "Expire-Date: 1m" >> genkey-batch
    gpg --batch --gen-key genkey-batch
    KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | grep -o -e '\/[A-Z0-9]*' | cut -c2-)
    echo ${KEY_ID}
    echo "Enter the key you would like to use: "
    read N
    echo $N
    KEY_ID=$N
    echo $KEY_ID
    PUBLIC_KEY=$(gpg --armor --export $KEY_ID)
    echo "Your public key is: ${PUBLIC_KEY}"
    git config --global user.signingkey $KEY_ID
    [ -f ~/.bashrc ] && echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
elif [[ $FLAG -eq 2 ]]
then
    #Choose one of the keys
    KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | grep -o -e '\/[A-Z0-9]*' | cut -c2-)
    echo ${KEY_ID}
    echo "Enter the key you would like to use: "
    read N
    echo $N
    KEY_ID=$N
    echo $KEY_ID
    PUBLIC_KEY=$(gpg --armor --export $KEY_ID)
    echo "Your public key is: ${PUBLIC_KEY}"
    git config --global user.signingkey $KEY_ID
    [ -f ~/.bashrc ] && echo 'export GPG_TTY=$(tty)' >> ~/.bashrc

else
    echo "Incorrect choice"
    #Check this line
    BASH "vcommit.sh"
fi
