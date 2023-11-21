cat << EOF >> ~/.ssh/config

Host ${hostname}
  HostName ${hostname}
  User ${user}
  Port 22
  IdentityFile ${identityfile}
EOF
