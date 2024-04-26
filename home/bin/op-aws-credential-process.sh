#!/bin/bash

account="$1"
vault="$2"
secret_id="$3"

set -x

op item get ${secret_id} --account=${account} --vault=${vault} --fields=label=AccessKeyId,label=SecretAccessKey --format=json | jq 'map({key: .label, value: .value}) | from_entries + {Version: 1}'
