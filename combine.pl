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


readEmployee("employee_info.csv");
readEmail("email_info.csv");
readDevice("device_info.csv");
readHttp("http_info.csv");
readLogon("logon_info.csv");
output();

sub output{
	foreach my $key(sort keys %userid2name){
		print $key;
		if(exists $userid2role{$key}){
			print "\,",$userid2role{$key};
		} else {
			print "\,0";
		}
		if(exists $userid2SizeS{$key}){
			print "\,",$userid2SizeS{$key};
		} else {
			print "\,0";
		}
		if(exists $userid2countS{$key}){
			print "\,",$userid2countS{$key};
		} else {
			print "\,0";
		}
		if(exists $userid2attachedS{$key}){
			print "\,",$userid2attachedS{$key};
		} else {
			print "\,0";
		}
		if(exists $userid2PCact{$key}{"day"}){
			print "\,",$userid2PCact{$key}{"day"};
		} else {
			print "\,0";
		}
		if(exists $userid2PCact{$key}{"night"}){
			print "\,",$userid2PCact{$key}{"night"};
		} else {
			print "\,0";
		}
		
		if(exists $userid2Httpact{$key}{"day"}){
			print "\,",$userid2Httpact{$key}{"day"};
		} else {
			print "\,0";
		}
		if(exists $userid2Httpact{$key}{"night"}){
			print "\,",$userid2Httpact{$key}{"night"};
		} else {
			print "\,0";
		}
		
		if(exists $userid2Logact{$key}{"day"}){
			print "\,",$userid2Logact{$key}{"day"};
		} else {
			print "\,0";
		}
		if(exists $userid2Logact{$key}{"night"}){
			print "\,",$userid2Logact{$key}{"night"};
		} else {
			print "\,0";
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


#collect the sum of size for all the email based on userid
#just count on the sender
sub readEmail{
	my $file = shift;
	open(FF,$file) || die;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			$userid2SizeS{$email2userid{$data[3]}} += $data[4];
			$userid2countS{$email2userid{$data[3]}}++;
			$userid2attachedS{$email2userid{$data[3]}}+=$data[5];
			#my @receiver = split(/\;/,$data[2]);
			#foreach my $uid(@receiver){
			#	$userid2SizeR{$email2userid{$uid}} += $data[4];
			#	$userid2countR{$email2userid{$uid}}++;
			#	$userid2attachedR{$email2userid{$uid}}+=$data[5];
			#}
		}
	}
	close(FF);
}
	
sub readDevice{
	my $file = shift;
	open(FF,$file) || die;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			my $time = "day";
			$data[1]=~/\d+\/\d+\/\d+ (\d+)\:\d+\:\d+/;
			if($1>8 and $1<18){
				$time = "day";
			} else {
				$time = "night";
			}
			$userid2PCact{$data[2]}{$time}++;
			$pc2act{$data[3]}{$time}++;
		}
	}
	close(FF);
	
	#foreach my $key(keys %pc2act){
	#	print $key;
	#	if(exists $pc2act{$key}{"day"}){
	#		print "\t",$pc2act{$key}{"day"};
	#	} else {
	#		print "\t",0;
	#	}
	#	if(exists $pc2act{$key}{"night"}){
	#		print "\t",$pc2act{$key}{"night"};
	#	} else {
	#		print "\t",0;
	#	}
	#	print "\n";
	#}
}

sub readHttp{
	my $file = shift;
	open(FF,$file) || die;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			my $time = "day";
			$data[1]=~/\d+\/\d+\/\d+ (\d+)\:\d+\:\d+/;
			if($1>8 and $1<18){
				$time = "day";
			} else {
				$time = "night";
			}
			$userid2Httpact{$data[2]}{$time}++;
		}
	}
	close(FF);
}



sub readLogon{
	my $file = shift;
	open(FF,$file) || die;
	while(my $ln=<FF>){
		chomp $ln;
		if($.==1){
			next;
		} else {
			my @data = split(/\,/,$ln);
			my $time = "day";
			$data[1]=~/\d+\/\d+\/\d+ (\d+)\:\d+\:\d+/;
			if($1>8 and $1<18){
				$time = "day";
			} else {
				$time = "night";
			}
			$userid2Logact{$data[2]}{$time}++;
		}
	}
	close(FF);
}
