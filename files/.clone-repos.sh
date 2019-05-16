#!/usr/bin/env bash

curl_github() {
  curl --silent -H "Authorization: Bearer ${GITHUB_PERSONALKEY}" https://api.${GITHUB_DOMAIN}/$1
}

clone_github() {
  if [ ! -d ${GITHUB_WORKSPACE} ]; then
    mkdir -p ${GITHUB_WORKSPACE}
  fi

  repos=$(curl_github "orgs/${GITHUB_ORG}/repos?per_page=100" | jq '.[].name')

  for repo in $repos
  do
    unquoted_repo=$(echo "$repo" | tr -d '"')

    echo "Cloning ${repo}"
    git clone git@github.com:${GITHUB_ORG}/${unquoted_repo}.git ${GITHUB_WORKSPACE}/$unquoted_repo> /dev/null
    if [ $? -eq 0 ]; then
      echo "Cloned ${repo}"
    else
      echo "Failed to clone ${repo}"
    fi
  done

  echo "Finished cloning all repositories"
  touch ${CLONED_MARKER}
}

is_cloned() {
  test -f ${CLONED_MARKER}
}

ping_github() {
  echo "Pinging github.com"
  curl -sfI https://${GITHUB_DOMAIN} -m 3 > /dev/null
}

# Retrieves settings from the .github_env file, or the user if not present
# Saves any retrieved user settings back to the .github_env file
fetch_settings() {
  if test -f ${WORKSPACE}/.github_env; then
    source ${WORKSPACE}/.github_env
  fi

  if [ -z "${GITHUB_PERSONALKEY}" ]; then
    read -p "Please enter your Github personal key: " GITHUB_PERSONALKEY    
  fi

  if [ -z "${GITHUB_ORG}" ]; then
    read -p "Please enter the Github organisation you wish to clone: " GITHUB_ORG
  fi

  echo "export GITHUB_PERSONALKEY=${GITHUB_PERSONALKEY}" > ${WORKSPACE}/.github_env
  echo "export GITHUB_ORG=${GITHUB_ORG}" >> ${WORKSPACE}/.github_env
}


GITHUB_DOMAIN="github.com"
WORKSPACE="${HOME}/workspace"
CLONED_MARKER="${WORKSPACE}/.cloned"

if ! is_cloned; then
  if ping_github; then
    echo "Successfully pinged Github, continuing"

    fetch_settings
    GITHUB_WORKSPACE="${WORKSPACE}/${GITHUB_ORG}"

    echo "Adding your private key to the keyring"
    source <(ssh-agent -s)
    ssh-add ~/.ssh/id_rsa
    echo "Cloning all repositories from $GITHUB_ORG into $WORKSPACE"
    clone_github
  else
    echo "Could not ping Github, aborting!"
  fi
else
  echo "Github repositories are already cloned. Done!"
fi
