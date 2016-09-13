#! /usr/bin/perl -w          
# -*- coding: utf-8 -*-
# pyword2tbl.pl --- Create a table for eim py input method
# Last modify Time-stamp: <Ye Wenbin 2007-07-12 20:48:30>
# Version: v 0.0 2006/07/17 06:29:58
# Author: Ye Wenbin <wenbinye@163.com>
#
###########################################################
# Xuehui YANG <jianghang@bagualu.net>
# updated on 2016/9/13
# get it worked on debian system, where 
#    1. the original `retrieve 'charpy.st'` will fail 
#    2. the pychr.txt is utf8 format
# 
# this file is to re-create the charpy.st
# just call it like: perl create_pychar.pl
#

use strict;
use warnings;
use Encode qw(encode decode from_to);
use Getopt::Long;
use Data::Dump qw(dump);
use Storable;

sub createCharpy {
    my $charfile = shift || "pychr.txt";
    my $coding = 'utf8';
    my %charpy;
    open(FH, $charfile) || die "Can't open file $charfile: $!";
    my $start = 0 ;
    while (<FH>) {
        chomp;
        #from_to($_, $coding, 'utf8');
 	#print $_;
	if ($_ eq "[Table]") {
	   $start = 1;
	   next;
	}
        if( $start < 1 ) { next; }

        my @r = split /\s+/;
	#print join("-",@r);
        foreach (1..$#r) {
            push @{$charpy{$r[$_]}}, $r[0];
        }
    }
    close FH;
    #print Dumper(%charpy) ;
    store \%charpy, 'charpy.st';
}

createCharpy()
