#!/bin/sh

CWD="/shared/httpd"
docker-compose exec --user root php71 env TERM=xterm /bin/sh -c "cd ${CWD}; exec bash -l"
