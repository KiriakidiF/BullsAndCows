#!/bin/bash

#based on lectures notes and hw04
export MIX_ENV=prod
export PORT=4795
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"
export SECRET_KEY_BASE=insecure

echo "Building..."

mix deps.get
mix compile

CFGD=$(readlink -f ~/.config/hw05)

if [ ! -d "$CFGD" ]; then
	mkdir -p $CFGD
fi

if [ ! -e "$CFGD/base" ]; then
	mix phx.gen.secret > "$CFGD/base"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE


(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest


echo "Generating release..."
mix release


echo "Starting app..."

PROD=t ./start.sh
