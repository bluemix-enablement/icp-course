#!/bin/bash
  sudo scp root@master:/etc/cfc/conf/oidc.crt /usr/local/share/ca-certificates/oidc.crt
  sudo update-ca-certificates
  sudo service docker restart
exit
