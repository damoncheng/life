#!/bin/bash

TIME=`date +%Y%m%d_%H%M%S`

mysqldump -hlocalhost -p1chx1222 --databases material > /data/hongxi_ziyi/mysqldump/material_${TIME}.sql

