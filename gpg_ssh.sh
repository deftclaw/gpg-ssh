# Enable gpg-ssh SOCK : 1705808365
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

function gpg-get-key() {
  gpg -k --keyid-format=long|ag -B1 "$1"
}

function gpg-get-id() {
  echo "$1"|ag '^\s'|awk -F' +' '{print $2}'
}

function gpg-generate() {
  templ8=/etc/xdg/templates/gpg.cfg
  config=${TMP:-/tmp}/unattended
  COMMENT=$2
  EMAIL=$3
  EXPIRE=$4
  KEYLGNTH=$5
  REALNAME=$1

  [[ -n $REALNAME ]] || read -p 'Real Name: '        REALNAME
  [[ -n $COMMENT ]]  || read -p 'Comment: '          COMMENT
  [[ -n $EMAIL ]]    || read -p 'Email Address: '    EMAIL
  [[ -n $KEYLGNTH ]] || read -p 'Key Length(bits): ' KEYLGNTH
  [[ -n $EXPIRE ]]   || read -p 'Expiration: '       EXPIRE

  sed "s/COMMENT/${COMMENT:-example}/" $templ8 > $config
  sed -i "s/EMAIL/${EMAIL:-name@example.com}/" $config
  sed -i "s/EXPIRE/${EXPIRE:-20250101T000000}/" $config
  sed -i "s/KEYLGNTH/${KEYLGNTH:-3072}/" $config
  sed -i "s/REALNAME/${REALNAME:-Example Name}/" $config

  gpg --expert --batch --full-generate-key $config
}

function gpg-search-delete() {
  # Guard clause, only run if there is an argument
  [[ $# -eq 1 ]] || error 'Usage:\n  gpg-delete <target_key>'

  found=`gpg-get-key "$1"`           # Locate and crop the necessary key parts
  desc=`echo $found|cut -d' ' -f3-9` # Scrape the trust and description
  key_id=`gpg-get-id "$found"`       # Scrape the Fingerprint

  echo "Selected Key: $desc"                  # Describe the selected key for confirmation
  read -p '  Confirm Deletion:(y/n) ' confirm # Collect confirmation
  [[ $(echo $confirm|ag 'y|Y') ]] || return   # Exit unless confirmed

  # Delete the selected secret key by fingerprint
  gpg --batch --yes --delete-secret-key "$key_id" 2>/dev/null \
    || reply -w "Failed to delete secret: ${desc[@]}"
  # Delete the selected public key by fingerprint
  gpg --batch --yes --delete-key "$key_id"        2>/dev/null \
    || error "Failed to delete: ${desc[@]}"
}
