#!/bin/bash


export MIX_ENV=prod
export PORT=4790

echo "Stopping old copy of app, if any..."

_build/prod/rel/hw05/bin/hw05 stop || true

echo "Starting app..."

_build/prod/rel/hw05/bin/hw05 start
