#----------------
#-     -     -   -    -
#|     |     |   |    |
#|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
#|     |     |   +------- month (1 - 12)
#|     |     +--------- day of        month (1 - 31)
#|     +----------- hour (0 - 23)
#+------------- min (0 - 59)


0 0 * * * /home/ec2-user/scripts/rotatelogs/rotatelogs.pl /home/ec2-user/scripts/rotatelogs/rotatelogs.conf > /dev/null