#!/bin/bash

CURRENT_DATE=`date +%F_%H-%M-%S`

date +%F_%H-%M-%S > /data/script/log/sync_grade_${CURRENT_DATE}.log
  
/usr/bin/python  /data/hongxi_ziyi/life/shelter/manage.py  sync_grade >> /data/script/log/sync_grade_${CURRENT_DATE}.log

date +%F_%H-%M-%S >> /data/script/log/sync_grade_${CURRENT_DATE}.log
