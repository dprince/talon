#!/bin/sh

pushd containers/tripleoclient
docker build -t tripleoclient:custom .
popd
