#!/bin/bash
#
# RUN ENTRYPOINT.

set -e
# AWS_CONFIG_FILE
# AWS_DEFAULT_OUTPUT
# AWS_SHARED_CREDENTIALS_FILE
# Write aws Creds if they don't exist
if [ -f /cncf/data/awsconfig  ] ; then
    echo "Creds Already Exist Don't Gen"
else
    cat <<EOF >data/awsconfig
[default]
output = ${AWS_DEFAULT_OUTPUT:-json}
region = ${AWS_DEFAULT_REGION:-ap-southeast-2}
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF
fi

# Run CMD
if [ "$@" = "" ] ; then
    # some silly issues around exporting cert
    make all
    # copy configured kubctl binary
    cp /usr/bin/kubectl data/kubectl
    mkdir -p data/.cfssl
    cp -a .cfssl/* data/.cfssl/*
elif [ "$1" = "deploy-cloud" ] ; then
    make all
elif [ "$1" = "deploy-demo" ] ; then
    kubectl create -f ~/.addons/ --recursive
elif [ "$1" = "destroy" ] ; then
    terraform get
    make terraform.tfvars
    make destroy
fi
