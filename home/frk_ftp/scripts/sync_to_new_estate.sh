#!/bin/sh

set -ex

source /home/frk_ftp/scripts/environment

rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$KANRI_IMAGE_HOST":/home/image/image_kanri/
rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$WWW1_HOST":/var/www/HomePlaza/img/image/
rsync -rlOtzv /home/frk_ftp/works/new_estate_images/  ocno_sys@"$WWW2_HOST":/var/www/HomePlaza/img/image/
