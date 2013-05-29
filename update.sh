#!/bin/sh
tar zxf *.tar.gz
rm -R bundle/static/files
ln -s upload bundle/static/files
./fiber.sh
./start.sh

