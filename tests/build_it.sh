#!/bin/bash
set -x

: ${NODE_VERSION?"NODE_VERSION has not been set."}

docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "sujith3g/meteord:node-${NODE_VERSION}-base" ../base && \
  docker tag "sujith3g/meteord:node-${NODE_VERSION}-base" sujith3g/meteord:base
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "sujith3g/meteord:node-${NODE_VERSION}-onbuild" ../onbuild && \
  docker tag "sujith3g/meteord:node-${NODE_VERSION}-onbuild" sujith3g/meteord:onbuild
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "sujith3g/meteord:node-${NODE_VERSION}-devbuild" ../devbuild && \
  docker tag "sujith3g/meteord:node-${NODE_VERSION}-devbuild" sujith3g/meteord:devbuild
docker build --build-arg "NODE_VERSION=${NODE_VERSION}" -t "sujith3g/meteord:node-${NODE_VERSION}-binbuild" ../binbuild && \
  docker tag "sujith3g/meteord:node-${NODE_VERSION}-binbuild" sujith3g/meteord:binbuild
