#!/bin/bash

set -e
set -x

release_name=${release_name:-"patroni-docker"}
manifest_dir=$PWD/manifest

cat > ~/.bosh_config <<EOF
---
aliases:
  target:
    bosh-lite: ${bosh_target}
auth:
  ${bosh_target}:
    username: ${bosh_username}
    password: ${bosh_password}
EOF

cd boshrelease-ci
mkdir -p tmp

cat > tmp/syslog.yml <<EOF
properties:
  remote_syslog:
    address: ${bosh_syslog_host}
    port: ${bosh_syslog_port}
    short_hostname: true
  docker:
    log_driver: syslog
    log_options:
    - (( concat "syslog-address=udp://" properties.remote_syslog.address ":" properties.remote_syslog.port ))
    - tag="{{.Name}}"
EOF

bosh target ${bosh_target}

export DEPLOYMENT_NAME=${deployment_name}
./templates/make_manifest warden embedded templates/services-solo.yml templates/jobs-etcd.yml tmp/syslog.yml

cp tmp/${DEPLOYMENT_NAME}*.yml ${manifest_dir}/manifest.yml
