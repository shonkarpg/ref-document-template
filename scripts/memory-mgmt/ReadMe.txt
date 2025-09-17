# chmod +x /root/free.sh
#----------------  https://crontab.guru/#0_22_*_*_1-5
#-     -     -   -    -
#|     |     |   |    |
#|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
#|     |     |   +------- month (1 - 12)
#|     |     +--------- day of        month (1 - 31)
#|     +----------- hour (0 - 23)
#+------------- min (0 - 59)
#MAILTO=abc@domain
* * * * * sh /root/free.sh
