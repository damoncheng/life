#!/bin/bash

CURRENT_DATE=`date +%F_%H-%M-%S`
date +%F_%H-%M-%S > /data/script/log/sync_course_${CURRENT_DATE}.log
/usr/bin/python  /data/hongxi_ziyi/life/shelter/manage.py  sync_course > /data/script/log/sync_course_${CURRENT_DATE}.log
date +%F_%H-%M-%S >> /data/script/log/sync_course_${CURRENT_DATE}.log
