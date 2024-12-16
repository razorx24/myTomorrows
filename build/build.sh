#!/bin/bash
set -ex

IMAGE_NAME="mytomorrows-app"
TAG="$(date "+%d%m%y-%H%M%S")"
REGISTRY="172221322213.dkr.ecr.us-east-1.amazonaws.com"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REGISTRY
docker build -t $IMAGE_NAME:$TAG .
docker tag $IMAGE_NAME:$TAG $REGISTRY/$IMAGE_NAME:$TAG
docker push $REGISTRY/$IMAGE_NAME:$TAG
