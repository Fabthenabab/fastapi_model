#!/bin/bash

PORT=${PORT}    # PORT=${PORT:DEFAULT_PORT}

docker run -it \
-v "$(pwd):/home/app" \
--env-file .env \
-p 4000:$PORT \
fastapi_unvicorn_img