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

mkdir -p creds/bundle
mkdir -p creds/doc-ver-api
mkdir -p creds/embedding-store

cp $pathToServiceAccountJson creds/bundle/gcs.json
cp $pathToServiceAccountJson creds/embedding-store/gcs.json

echo "LICENSE_KEY=\"$licenceKey\"" > creds/doc-ver-api/.env

cdir="$(pwd)"

if [ ! -f "$cdir/docker-compose.yaml" ]; then
  echo "Expected to be positioned in the folder containing the docker-compose.yaml for docver"
fi

printf "REL_DIR=%s\n" "$cdir" > .env