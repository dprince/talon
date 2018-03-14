if [ -n "$USER" -a -n "$UID" ]; then
  useradd "$USER" -u "$UID" -M
cat >> /etc/sudoers <<EOF_CAT
$USER ALL=(ALL) NOPASSWD:ALL
EOF_CAT
  su -l $USER
  export TERM="xterm"
  alias ls='ls --color=auto'
  /bin/bash
else
  echo "Please set valid $USER and $UID env variables."
  exit 1
fi
