

mysqldump -h <Server> --skip-lock-tables -u<DBuser> -p<Password> <dbname> --routines | gzip > /opt/live-RDS-backup/temp/<dbname>-$(date +%Y-%m-%d-%H_%M_%S).gz

ls -lR --time-style=+%Y-%m-%d
