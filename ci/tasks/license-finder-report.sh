#!/bin/bash

# license_finder report

set -e -x

cd boshrelease

submodules=(dingo-postgresql-broker cf-containers-broker dingo-postgresql-clusterdata-backup)
for submodule in ${submodules[@]}; do
  pushd src/$submodule
    echo License Report for $submodule
    license_finder report
  popd
done