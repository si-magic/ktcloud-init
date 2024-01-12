#!/bin/bash

# Set the hostname to that of DHCP lease.

set -e
. "$(dirname "${BASH_SOURCE[0]}")/common"

DHCP_HOST="$(get_dhcpopt host-name)"
hostnamectl set-hostname "$DHCP_HOST"
