#!/bin/sh

aws s3 cp /home/frk_ftp/works/agents "s3://recat-staging/estates_import/frk/$(date +%Y%m%d)/" --recursive --exclude '*' --include '*.csv'
