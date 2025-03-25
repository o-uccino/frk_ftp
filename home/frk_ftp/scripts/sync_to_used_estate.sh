#!/bin/bash
set -ex

source /home/frk_ftp/scripts/environment

SSH_KEY_PATH="$HOME/.ssh/ocno_sys.pem"

export RSYNC_RSH="ssh -i $SSH_KEY_PATH -o KexAlgorithms=diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1 -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=ssh-rsa,ssh-dss -o StrictHostKeyChecking=no"
rsync -rlOtzv /home/frk_ftp/works/used_estate_images/ ocno_sys@"$CO_FTP_HOST":/usr/image/
