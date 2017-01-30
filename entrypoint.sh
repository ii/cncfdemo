#!/bin/bash
#
# RUN ENTRYPOINT.

set -e

# Write aws Creds if they don't exist
if [ "$(ls -A /root/.aws)" ]; then
    echo "Creds Already Exist Don't Gen"
else
    cat <<EOF >/root/.aws/credentials
[default]
aws_access_key_id = ${AWS_ID}
aws_secret_access_key = ${AWS_KEY}
EOF
    cat <<EOF >/root/.aws/config
[default]
output = ${OUTPUT:-json}
region = ${CONFIG_REGION:-us-east-1}
aws_access_key_id = ${AWS_ID}
aws_secret_access_key = ${AWS_KEY}
EOF
fi

# Run CMD
if [ "$@" = "" ] ; then
    make all
elif [ "$1" = "deploy-cloud" ] ; then
    make all
elif [ "$1" = "deploy-demo" ] ; then
    kubectl create -f ~/.addons/ --recursive
elif [ "$1" = "destroy" ] ; then
    make destroy
fi
