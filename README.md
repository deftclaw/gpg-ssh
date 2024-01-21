# Using SSH with GPG
_Shortcuts as described by [gpg-ssh-setup](https://gist.github.com/deftclaw/a0de41d71e2248327e1387fd263f67ca)_  

---  

## Installation:
1. Clone the repository:  
    - `git clone https://github.com/deftclaw/gpg-ssh`  
2. Enter the folder:  
    - `pushd git-ssh`  
3. Install the files(script will ask for sudo):  
    - `./install`  
4. New functions have been installed to `/etc/profile.d` so reload them:  
    - `. /etc/profile`  

## Usage:  
1. Generate your gpg key: _Prompts will ask you for your details_  
    - `gpg-generate`  
2. Enable gpg-ssh:  `./enable_gpg-ssh.sh`  
3. Backup your keys: `./gpg_backup.sh <key_id>`  
4. Add a new ssh-configuration:  
    - `nnash`  
