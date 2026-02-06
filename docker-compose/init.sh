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

if [ ! -f conf/doc-ver-image/.env ] && [ -f conf/doc-ver-image/.env.example ]; then
  cp conf/doc-ver-image/.env.example conf/doc-ver-image/.env
fi

update_env_var() {
  local key="$1"
  local value="$2"
  local file="conf/doc-ver-image/.env"
  local escaped_value

  escaped_value="$value"
  escaped_value="${escaped_value//\\/\\\\}"
  escaped_value="${escaped_value//&/\\&}"
  escaped_value="${escaped_value//|/\\|}"

  if grep -q "^${key}=" "$file"; then
    sed -i '' "s|^${key}=.*|${key}=\"${escaped_value}\"|" "$file"
  else
    printf '%s\n' "${key}=\"${escaped_value}\"" >> "$file"
  fi
}

update_env_var "LICENSE_KEY" "$licenceKey"
update_env_var "APPLICATION_ID" "$licensee"

cdir="$(pwd)"

if [ ! -f "$cdir/docker-compose.yaml" ]; then
  echo "Expected to be positioned in the folder containing the docker-compose.yaml for docver"
fi

printf "REL_DIR=%s\n" "$cdir" > .env