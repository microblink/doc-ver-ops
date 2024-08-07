#!/bin/bash

deploymentName="$1"
licenceKey="$2"
licensee="$3"

if [ -z "$licenceKey" ]; then
  echo "Licence key is required as a second argument"
  exit 1
fi

if [ -z "$licensee" ]; then
  licensee="localhost"
fi

# Check if license key starts with string "sRw"
if [[ $licenceKey != sRw* ]]; then
  echo "License key is invalid"
  echo "License key string should start with 'sRw' please check the license key and try again."
  exit 1
fi

cp -r template $deploymentName

cd $deploymentName

mkdir -p creds/doc-ver-runner

echo "LICENSE_KEY=\"$licenceKey\"" > creds/doc-ver-runner/.env
echo "APPLICATION_ID=\"$licensee\"" >> conf/doc-ver-runner/.env

cdir="$(pwd)"

if [ ! -f "$cdir/docker-compose.yaml" ]; then
  echo "Expected to be positioned in the folder containing the docker-compose.yaml for docver"
fi

printf "REL_DIR=%s\n" "$cdir" > .env