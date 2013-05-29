#!/bin/bash
NODE_DEBUG=--debug \
ROOT_URL=http://files.42do.ru/ \
PORT=80 \
MONGO_URL=mongodb://localhost/42do-pagi \
MAIL_URL=smtp://localhost:25 \
node bundle/main.js
