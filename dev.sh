#!/bin/bash

export $(grep -v '^#' .env | xargs)

concurrently "bunx tailwindcss -i ./src/templates/tailwind.input.css -o ./src/assets/styles.css --watch" "v -cg -d vweb_livereload watch run ./src"

