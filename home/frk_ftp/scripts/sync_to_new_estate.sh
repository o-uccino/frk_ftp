#!/bin/sh

set -ex

source /home/frk_ftp/scripts/environment

SSH_KEY_PATH="$HOME/.ssh/ocno_sys.pem"

export RSYNC_RSH="ssh -i $SSH_KEY_PATH -o KexAlgorithms=diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1 -o HostKeyAlgorithms=ssh-rsa,ssh-dss -o PubkeyAcceptedKeyTypes=ssh-rsa,ssh-dss -o StrictHostKeyChecking=no"

rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$KANRI_IMAGE_HOST":/home/image/image_kanri/
rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$WWW1_HOST":/var/www/HomePlaza/img/image/
rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$WWW2_HOST":/var/www/HomePlaza/img/image/
