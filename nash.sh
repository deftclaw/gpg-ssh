# Quickly add / modify ssh configs : 

function nnash() {
  [[ -d $HOME/.ssh ]] || mkdir -m 700 $HOME/.ssh
  [[ -d $HOME/.ssh/config.d ]] || (
    mkdir -m 755 $HOME/.ssh/config.d
    echo 'Include config.d/*' > $HOME/.ssh/config
  )

  # Assign config in order if supplied
  NICKNAME=$1
  HOST=$2
  USERNAME=$3

  # Ensure each variable has a value with own username as default
  [[ -n $HOST ]]     || read -p 'Hostname: '           HOST
  [[ -n $NICKNAME ]] || read -p 'Host-Nickname: '      NICKNAME
  [[ -n $USERNAME ]] || read -p "Username: [${USER}] " USERNAME

  templ8=$XH/templates/ssh.cfg
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
