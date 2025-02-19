#!/bin/sh

find /home/frk_ftp/agents/ -type f -print0 | \
    xargs -0 -I% \
          sudo rsync -rlOtzv --remove-source-files \
          --include='*/' \
          --include='*.jpg' \
          --include='*.csv' \
          --include='*.tgz' \
          --include='sent' \
          --exclude='*' \
          % /home/frk_ftp/works/agents

sudo chown -R ocno_sys:ocno_sys /home/frk_ftp/works/agents
