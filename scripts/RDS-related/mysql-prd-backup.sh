#!/bin/bash
# Db backup for  PName prd
# Applications:
# This backup is scheduled to run at every day 18:30 IST
THEDBUSER="prd_master"
THEDBPW="DBPASSWORD"
THEDATE=$(date +%Y-%m-%d)
THEDATET=$(date +"%Y%m%d:%H%M")
THEDATETT=$(date +"%Y%m%d%H%M")
PNameRDS="/root/backup/mysql-backup"
PRD="DBServer"
mkdir ${PNameRDS}/${THEDATE}
#PName-prd
mysqldump --skip-lock-tables -h $PRD -u $THEDBUSER -p${THEDBPW} PName --routines | gzip > ${PNameRDS}/${THEDATE}/PName${THEDATET}.prd.sql.gz
echo " backup finished on  ${THEDATETT}"