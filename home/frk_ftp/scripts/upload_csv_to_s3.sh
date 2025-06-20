#!/bin/sh

source /home/frk_ftp/scripts/environment

aws s3 cp /home/frk_ftp/agents/ "s3://${RECAT_S3_BUCKET}/estates_import/frk/$(date +%Y%m%d)/" --recursive --exclude '*' --include '*.csv' --include '*.xml' || :
