#!/bin/bash
# backup xx.xxx.xxx.xx (domainname) /home/ec2-user/backup/app-backup/backup & /Prd-backup/efront/
THEDBUSER="root"
THEDBPW="dbpass-21"
THEDATE=$(date +%Y-%m-%d)

mkdir -p /home/ec2-user/backup/app-backup/backup/${THEDATE}

sudo tar -czf /home/ec2-user/backup/app-backup/backup/${THEDATE}/tao-app-${THEDATE}.tar.gz /var/www/html/

mysqldump --skip-lock-tables -u $THEDBUSER -p${THEDBPW} tao_db --routines | gzip >  /home/ec2-user/backup/app-backup/backup/${THEDATE}/tao_db_${THEDATE}.sql.gz
# Removes backup directories 8 days older
sudo find /home/ec2-user/backup/app-backup/backup/* -mtime +8 -exec rm -r {} \;
#To remove all empty directories in a directory tree you would run:

sudo find /home/ec2-user/backup/app-backup/backup/ -type d -empty -delete
