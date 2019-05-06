# ssb-over-ssh

## goal
run an ssb app on a local machine, while running the main sbot (ssb-server) on a remote server. tunnel the relevant ports (8008/8007) through SSH.

## basics
- create a cloud server (Ubuntu)
- lock down everything but ssh and localhost ssb
  ```bash
  sudo ufw default deny incoming
  sudo ufw allow OpenSSH
  sudo ufw allow from 127.0.0.1 to any port 8008 proto tcp
  sudo ufw allow from 127.0.0.1 to any port 8007 proto tcp
  sudo ufw allow from 127.0.0.1 to any port 8989 proto tcp # for ssb-ws
  sudo ufw allow from 127.0.0.1 to any port 8043 proto tcp # for ssb-npm-registry if needed
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

## patchfoo
patchfoo is easy because everything can run on the server and the local machine can just hit the web service tunneled through ssh. 
- install patchfoo from [this guide](http://git.scuttlebot.io/%25YAg1hicat%2B2GELjE2QJzDwlAWcx0ML%2B1sXEdsWwvdt8%3D.sha256)
  i opted for installing it as a plugin
- tunnel 8027 through ssh
  ```bash
  ssh -L 8027:localhost:8027 user@server
  ```
- browse to http://localhost:8027 locally and smile

## scat/gester
this app needs to connect to what it thinks is a local ssb instance, so it needs the secret and manifest.json files present in `~/.ssb`. **This is probably dangerous and could fork your identity so proceed at your own risk.**

- copy these two files from the remote server to the local client
  ```bash
  ~/.ssb/secret
  ~/.ssb/manifest.json
  ```
- install `ssb-chat` or [gester](https://github.com/stripedpajamas/gester)
  ```bash
  npm i -g ssb-chat
  ```
- make sure to tunnel the needed ports
  ```bash
  ssh -L 8008:localhost:8008 user@server
  ```
- run scat/gester locally and smile
  ```bash
  scat
  ```

## patchbay
patchbay is set up to use a unix socket to connect to the sbot instance and it also is looking for `~/.ssb/manifest.json` and `~/.ssb/secret` (again, **this is probably dangerous and could fork your identity so proceed at your own risk.**). so those two files need to come down locally and the `config.js` file in patchbay needs some alterations.

- install all the plugins needed (i used `patchbay/server.js` as reference)
- copy down `manifest.json` and `secret` locally
- comment out `config = addSockets(config)` in `patchbay/config.js`
- make sure to tunnel the needed ports
  ```bash
  ssh -L 8008:localhost:8008 8989:localhost:8989 user@server
  ```
- run patchbay in dev mode and smile
  ```bash
  npm run dev
  ```

i wrote [a small bash script](https://github.com/stripedpajamas/ssb-over-ssh/blob/master/pb.sh) to automate this on my own machine. you can download the script and add `alias pb=path/to/pb.sh` to your `.bash_profile` etc. and then run `pb` to start patchbay. check the comments in the script for assumptions made.

## yap
yap is browser based so it's very easy to get going over ssh.

- install and run [yap](https://github.com/dominictarr/yap) on the ssh server (git clone + npm install + node index.js)
- tunnel the needed port
  ```bash
  ssh -L 8005:localhost:8005 user@server
  ```
- browse to http://localhost:8005/public locally and smile

## tips
- i typically use `ssh -NL <port>:localhost:<port> host` and the `N` makes it not drop into a shell.
- sometimes i chain multiple port bindings together like `ssh -NL <port1>:localhost:<port1> -L <port2>:localhost:<port2> host`

## todo
- patchwork (I don't think external sbot is supported at this time)

