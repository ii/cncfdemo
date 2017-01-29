#!/bin/bash
#
# RUN ENTRYPOINT.
# Write aws Creds

set -e

#mkdir ~/.aws
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
output = ${OUTPUT}
region = ${CONFIG_REGION}
aws_access_key_id = ${AWS_ID}
aws_secret_access_key = ${AWS_KEY}
EOF
fi



if [ "$ACTION" = "deploy" ]; then
    make all

elif [ "$ACTION" = "manifests" ]; then
    kubectl create -f ~/.addons/ --recursive
    fi
