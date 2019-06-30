#!/usr/bin/env bash
# hooks/pre_configure.d/generate_fqdn.sh

export HOSTNAME_FQDN=$(hostname -f)
