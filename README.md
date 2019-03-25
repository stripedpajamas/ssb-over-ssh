# ssb-over-ssh

## goal
run an ssb app like patchbay on a local machine, while running the main sbot (ssb-server) on a remote server. tunnel the relevant ports (8008/8007) through SSH.

## basics
- create a cloud server (Ubuntu)
- lock down everything but ssh and localhost ssb
  ```bash
  sudo ufw default deny incoming
  sudo ufw allow OpenSSH
  sudo ufw allow from 127.0.0.1 to any port 8008 proto tcp
  sudo ufw allow from 127.0.0.1 to any port 8007 proto tcp
  sudo ufw allow from 127.0.0.1 to any port 8043 proto tcp # for ssb-npm-registry if desired
  sudo ufw enable
  ```
- install node/npm
  ```bash
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
  nvm install 9
  ```
- install and start `ssb-server`
  ```bash
  npm i -g ssb-server
  ssb-server start
  ```
- copy secret and manifest.json locally
  *this is probably kind of dangerous and could lead to forking your identity*
  ```bash
  # these two files need to be copied from the remote server
  # to the local machine
  ~/.ssb/secret
  ~/.ssb/manifest.json
  ```
  
  
## tunnel local ssb traffic through ssh to remote server
```bash
ssh -L 8008:<public server ip>:8008 ssb
```

## test it out
on the local machine, see if it can connect to the remote ssb-server and get the `whoami` response
```bash
ssb-server whoami
```


