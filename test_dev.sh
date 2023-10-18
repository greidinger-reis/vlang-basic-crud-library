#!/bin/bash

export API_PORT=3000
export DB_PORT=5432
export DB_NAME=pg
export DB_HOST=localhost
export DB_USER=dev
export DB_PASSWORD=dev
export AUTH_SECRET=some_secret
export AUTH_EXP_TIME_SECONDS=604800

v -stats test ./src