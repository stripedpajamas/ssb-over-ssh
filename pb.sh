#!/bin/bash

# this script assumes `ssb` is an ssh host alias in ~/.ssh/config
# this script assumes $PATCHBAY_DIR points to a git clone of patchbay
# this script assumes Mac OS (for the sed command)

# kill ssh tunnel when exiting
trap "exit" INT TERM ERR
trap "kill 0" EXIT

# copy manifest.json and secret locally
scp ssb:'~/.ssb/manifest.json ~/.ssb/secret' ~/.ssb

# modify patchbay/config
pushd $PATCHBAY_DIR
git checkout -- . # return everything to defaults
git pull origin master # update code
sed -i '' "s/config = addSockets/\/\/ config = addSockets/" config.js # don't add sockets

# ssh tunnel
ssh -NL 8008:localhost:8008 -L 8989:localhost:8989 ssb &

# run it
npm run dev
popd
