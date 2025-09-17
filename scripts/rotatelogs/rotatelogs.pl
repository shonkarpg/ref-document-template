#!/usr/bin/perl

$gzip = "/bin/gzip";
$cat = "/bin/cat";


($conf, $debug) = @ARGV;

$d = &GetDate(time - 60*60*12);
open(CONF, "$conf") || die $!;
while(<CONF>) {
    chomp();
    my ($logdir, $filename, $uid, $gid) = split("\t");
    if ($logdir ne '' && $filename ne '') {
        &RotateLog($logdir, $filename, $d, $uid, $gid);
    }
}
close(CONF);
exit;



sub RotateLog{
    my ($logdir, $filename, $suffix, $uid, $gid) = @_;
    my @fstat = stat("$logdir/$filename");
    print "$logdir/$filename:\t". int($fstat[7]/1024). "KB\n";

    if (-e "$logdir/$filename\.$suffix.gz") {
        $suffix = "$suffix-$$";
    }
    my $cmd = "$gzip -c $logdir/$filename > $logdir/$filename\.$suffix.gz; $cat /dev/null > $logdir/$filename";
    if ($debug == 0) {
        system("$cmd");
        if ($uid > 0 && $gid > 0) {
                #chown($uid, $gid, "$filename\.$suffix");
        }
    } else {
        print "$cmd\n";
    }

}
##################################################
### æçãYYYMMDD)
### @USAGE
###  $date = GetDate($time)
### @PARAM
###  t æ1970年1æ¥0æ0çãç¼
### @RETURN
###  (YYYYMMDD)
##################################################
sub GetDate{
    my ($t) = @_;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($t);
    $year += 1900;
    $mon++;
    my $d = sprintf("%d%02d%02d", $year, $mon, $mday);
    return $d;
}
