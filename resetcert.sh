#!/bin/bash
  sudo cp oidc.crt /usr/local/share/ca-certificates/oidc.crt
  sudo update-ca-certificates
  sudo service docker restart
exit
