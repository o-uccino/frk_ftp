date=`date "+%Y-%m-%d-%H"`
aws s3 cp /home/frk_ftp/works/agents/ s3://recat/estates_import/frk/$date/ --recursive --exclude '*' --include '*.csv'
