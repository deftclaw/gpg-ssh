#!/usr/bin/env bash

# Enable using gpg-key for ssh-authentication
echo 'enable-ssh-support' >> $HOME/.gnupg/gpg-agent.conf

# Add pgp key to the list of ssh keys
keygrip=`gpg -k --with-keygrip|tail -n 3|head -n 1|awk '{print $NF}'`
echo "${keygrip} 5" >> $HOME/.gnupg/sshcontrol
ssh-add -l

# Enable pgp signing of git commits
git config --global --unset gpg.format
keyID=`gpg -K --keyid-format=long|tail -n 4|head -n 1|awk -F' +|/' '{print $3}'`
git config --global user.signingkey ${keyID}

echo -e "\033[38;5;42mRemember to \`gpg --export-ssh-key\`\033[0m"
