#/usr/bin/env perl

use threads ('exit'=>'threads_only');
use threads::shared;

open(LIST,@ARGV[0]);
my @list:shared = <LIST>;
close(LIST);
while (1) {
  $running=threads->list(threads::runing);$list=@list;
  if (($running < @ARGV[1]) && ($list > 0)) {threads->new(\&job);}
  $running=threads->list(threads::runing);$list=@list;
  if ($running >= @ARGV[1]) {sleep(1);} else {if ($list > 0) {next;}}
  if ($running > 0) {foreach $tmp(threads->list(threads::all)) {if ($tmp->is_joinable()){$tmp->join();}}}
  last if ($list == 0);
}
foreach $tmp(threads->list(threads::running)) {$tmp->join();}
sub job {$tmp = shift(@list);$tmp=~s/\n//;if ($tmp) {$thr = threads->tid();system "$tmp $thr\n";exit(1);}}
