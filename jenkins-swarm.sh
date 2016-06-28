#! /bin/bash

set -e

# if `docker run` first argument start with `-` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then
   exec java $JAVA_OPTS -jar swarm-client-2.0-jar-with-dependencies.jar "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"


