#!/bin/bash

export $(grep -v '^#' .env | xargs)

v -color -prod ./src -o dist/src

cd dist

chmod +x ./src

./src