#These commands are non-destructive and it will release unused memory only and will not affect any process of the system. 
#As we have execute the sync command so it will remove the all unused Objects which are not free and used unused memory.

#make sure all cached objects are freed
sync

#To free pagecache:
echo 1 > /proc/sys/vm/drop_caches

#To free dentries and inodes:
echo 2 > /proc/sys/vm/drop_caches

#To free pagecache, dentries and inodes:
echo 3 > /proc/sys/vm/drop_caches