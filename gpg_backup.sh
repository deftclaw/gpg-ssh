#!/bin/bash

[[ $# -eq 1 ]] || return 1
key="$1"

gpg -a --export-secret-keys "$key" > "${key}.pem.asc"
gpg --export-ownertrust > ownertrust.txt
