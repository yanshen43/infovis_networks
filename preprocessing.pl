#!/usr/bin/perl -w
use strict;

my $file = $ARGV[0];

open(FF,$file) || die;
my %start;
my %value;
my $i=0;
while(my $ln=<FF>){
	chomp $ln;
	if($.==1){
		next;
	} elsif($.==2){
		my @ddt = split(/\,/,$ln);
		#05/01/2017 01:58:03
		$ddt[1]=~/(\d+)\/(\d+)\/(\d+) (\d+)\:(\d+)\:(\d+)/;
		$start{'mon'} = $1;
		$start{'day'} = $2;
		$start{'year'} = $3;
		$start{'hour'} = $4;
		$start{'minute'} = $5;
		$start{'second'} = $6;
		$value{$i++} = 0;
	} else {
		chomp $ln;
		my @ddt = split(/\,/,$ln);
		$value{$i++} = convertToTime($ddt[1]);
	}
}


foreach my $key(sort {$a<=>$b} keys %value){
	print $value{$key},"\n";
}


sub convertToTime{
	my $time = shift;
	$time=~/(\d+)\/(\d+)\/(\d+) (\d+)\:(\d+)\:(\d+)/;
	my $relativeTime = ($1-$start{'mon'})*31*24*60+($2-$start{'day'})*24*60+($4-$start{'hour'})*60+($5-$start{'minute'})+(($6-$start{'second'})/60);
	return($relativeTime);
}
