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
readEmail("email_info.csv");
output();

sub output{
	foreach my $key(sort keys %userid2name){
		print $key;
		if(exists $userid2role{$key}){
			print "\,",$userid2role{$key};
		} else {
			print "\,0";
		}
		foreach my $tt(@tdata){
			if(exists $userid2SizeS{$key}{$tt}){
				print "\,",$userid2SizeS{$key}{$tt}/$userid2countS{$key}{$tt};
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
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			$userid2name{$data[2]} = $data[1];
			$userid2email{$data[2]} = $data[3];
			$userid2role{$data[2]} = $data[4];
			$email2userid{$data[3]} = $data[2];
		}
	}
	close(FF);
}



sub readEmail{
	my $file = shift;
	open(FF,$file) || die;
	my $i=0;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			my $time = [split(/ /,$data[1])]->[0];
			if(not exists $timerange{$time}){
				$tdata[$i++] = $time;
				$timerange{$time} = 1;
			}
			$userid2SizeS{$email2userid{$data[3]}}{$time}+= $data[4];
			$userid2countS{$email2userid{$data[3]}}{$time}++;
			$userid2attachedS{$email2userid{$data[3]}}{$time}+=$data[5];
		}
	}
	close(FF);
}
