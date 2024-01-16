#!/usr/bin/env bash

echo 'enable-ssh-support' >> $HOME/.gnupg/gpg-agent.conf
sudo cp gpg_ssh.sh /etc/profile.d/

keygrip=`gpg -k --with-keygrip|tail -n 2|head -n 1|awk '{print $NF}'`
echo "${keygrip} 5" >> $HOME/.gnupg/sshcontrol
ssh-add -l

echo -e "\033[38;5;42mRemember to \`gpg --export-ssh-key\`\033[0m"
