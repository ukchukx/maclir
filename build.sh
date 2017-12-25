#!/bin/bash
source .env
mix deps.get --only prod
cd assets
npm install
./node_modules/brunch/bin/brunch build --production
cd ..
MIX_ENV=prod mix do phx.digest, release --verbose
MIX_ENV=prod mix do ecto.create
MIX_ENV=prod mix do event_store.setup
MIX_ENV=prod mix do ecto.migrate, event_store.migrate, mac_lir.reset
./build_docker.sh
