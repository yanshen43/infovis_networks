#!/usr/bin/perl -w
use strict;

my %user;
my %userid2name;
my %userid2role;
my %userid2email;
my %email2userid;
my %userid2SizeS;
my %userid2PCact;
my %userid2Httpact;
my %userid2Logact;
my %pc2act;
my %userid2countS;
my %userid2attachedS;
my @tdata;
my %timerange;

readEmployee("employee_info.csv");
#readEmail("email_info.csv");
#readDevice("device_info.csv");
#readHttp("http_info.csv");
#readLogon("logon_info.csv");
output();

sub output{
	foreach my $key(sort keys %userid2name){
		print $key;
		foreach my $tt(@tdata){
			if(exists $userid2name{$key}{$tt}){
				print "\,",$userid2name{$key}{$tt};
			} else {
				print "\,0";
			}
		}
		print "\n";
	}
}

sub readEmployee{
	my $file = shift;
	open(FF,$file) || die;
	my $i=0;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			if(not exists $timerange{$data[0]}){
				$tdata[$i++] = $data[0];
				$timerange{$data[0]} = 1;
			}
			$userid2name{$data[2]}{$data[0]} = 1;
		}
	}
	close(FF);
}
