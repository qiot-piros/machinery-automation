#!/bin/bash

# not yet fully functional
podman run --rm -v .:/runner:z quay.io/ansible/ansible-runner:stable-2.9-devel ansible-playbook -i inventory/ playbooks/configure-fitlet.yaml
