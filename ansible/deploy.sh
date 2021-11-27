#!/bin/bash

if [ "$2" == "" ]; then
  echo "need container image and container image version as parameters"
  echo "ex: $0 quay.io/tim_speetjens/machinery-service 1.0.0-SNAPSHOT-8"
  exit 1
fi

EXTRA_VARS="--extra-vars container_image=$1 --extra-vars container_image_version=$2"

identity_file=${ANSIBLE_IDENTITY_FILE:-${HOME}/.ssh/id_rsa}
mkdir -p ./.ssh
cp ${identity_file} ./.ssh/
ansible_identity_file=$(cd .ssh/ && pwd)/$(basename $identity_file)

podman run --rm -v ${ansible_identity_file}:/runner/identity_file:z -v .:/runner:z \
--env ANSIBLE_HOST_KEY_CHECKING=False \
--env ANSIBLE_BECOME_PASS \
quay.io/ansible/ansible-runner:stable-2.9-devel \
ansible-playbook -i inventory/ --private-key=/runner/identity_file playbooks/configure-fitlet.yaml $EXTRA_VARS
