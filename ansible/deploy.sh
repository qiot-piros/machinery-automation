#!/bin/bash

identity_file=${ANSIBLE_IDENTITY_FILE:-${HOME}/.ssh/id_rsa}
mkdir -p ./.ssh
cp ${identity_file} ./.ssh/
ansible_identity_file=$(cd .ssh/ && pwd)/$(basename $identity_file)

podman run --rm -v ${ansible_identity_file}:/runner/identity_file:z -v .:/runner:z \
--env ANSIBLE_HOST_KEY_CHECKING=False \
--env ANSIBLE_BECOME_PASS \
quay.io/ansible/ansible-runner:stable-2.9-devel \
ansible-playbook -i inventory/ --private-key=/runner/identity_file playbooks/configure-fitlet.yaml
