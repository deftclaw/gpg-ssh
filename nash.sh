# Quickly add / modify ssh configs : 1705811258

function nnash() {
  # Assign config in order if supplied
  NICKNAME=$1
  HOST=$2
  USERNAME=$3

  # Ensure each variable has a value with own username as default
  [[ -n $NICKNAME ]] || read -p 'NICKNAME: ' NICKNAME
  [[ -n $HOST ]]     || read -p 'HOSTNAME: ' HOST
  [[ -n $USERNAME ]] || read -p "USERNAME: [${USER}] " USERNAME

  templ8=/etc/xdg/templates/ssh.cfg
  leaf=$HOME/.ssh/config.d/${NICKNAME}
  sed "s/NICKNAME/${NICKNAME}/" $templ8 > $leaf
  sed -i "s/HOSTNAME/${HOST}/" $leaf
  sed -i "s/USERNAME/${USERNAME:=$USER}/" $leaf
}

function nash() {
  branch=$HOME/.ssh/config.d
  leaf=$1
  [[ -n $leaf ]] || (
    ls ${branch}
    read -p 'Choose config: ' leaf
  )
  nvim ${branch}/${leaf}
}
