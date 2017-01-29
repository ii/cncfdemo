#!/bin/bash
#
# RUN ENTRYPOINT.

set -e

# Write aws Creds if they don't exist
mkdir -p ~/.aws
if [ ! -f /root/.aws/credentials ] ; then
   cat <<EOF >/root/.aws/credentials
[default]
aws_access_key_id = ${AWS_ID}
aws_secret_access_key = ${AWS_KEY}
EOF
fi

if [ ! -f /root/.aws/config ] ; then
cat <<EOF >/root/.aws/config
[default]
output = ${OUTPUT}
region = ${CONFIG_REGION}
aws_access_key_id = ${AWS_ID}
aws_secret_access_key = ${AWS_KEY}
EOF
fi

# Run CMD
if [ "$@" = "" ] ; then
    echo make all
elif [ "$1" = "deploy-cloud" ] ; then
    echo make all
elif [ "$1" = "deploy-demo" ] ; then
    echo kubectl create -f ~/.addons/ --recursive
elif [ "$1" = "destroy" ] ; then
    echo make destroy
fi
