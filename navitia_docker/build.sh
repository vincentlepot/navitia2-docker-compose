#!/bin/bash

export NAVITIA_VERSION="2.9.0"
docker build --build-arg navitia_version="${NAVITIA_VERSION}" -t zibok/navitia2:${NAVITIA_VERSION} .
