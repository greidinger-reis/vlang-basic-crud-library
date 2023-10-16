#!/bin/bash

export API_PORT=3000
export DB_PORT=5432
export DB_NAME=pg
export DB_HOST=localhost
export DB_USER=dev
export DB_PASSWORD=dev

v -color -prod ./src -o dist/src

cd dist

chmod +x ./src

./src