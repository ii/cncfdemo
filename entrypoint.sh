#!/bin/bash
#
# RUN ENTRYPOINT.
# Write aws Creds

set -e

mkdir ~/.aws
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

sleep 10000000000
