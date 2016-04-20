#! /bin/bash

ADI_WWWW=/srv/new-adi-website/www
DOCKERFILE=Dockerfile
NAME="new-adi-website"

# Validate nginx configurations
nginx -t
if [ $? -ne 0 ]; then
    echo "Nginx config failed!"
    exit
fi

# Kill the old container
docker kill $NAME
docker rm $NAME

# Startup the new container
docker build -t $NAME .

# --net: Use the local network stack
# --restart: Always restart, even if it crashes
# -v: mount a volume, to ensure that edited log files live on the server,
#     not in the docker box.
# --volumes-from: Mount the uploaded images filesystem, so that new image
#                 live on the server, not in the docker box.
# -d: detach after running, instead of entering the container
# --name: Set the name of the container

docker run \
    --net=host \
    --restart=always \
    -v $ADI_WWW/../logs:/opt/logs \
    --volumes-from uploaded-images \
    -d \
    --name="$NAME" $NAME
