#!/usr/bin/env -S perl

# Reformator Perl script
# ----------------------

use warnings;
use strict;
use utf8;
use 5.010;
use Getopt::Long;

my $VERSION = '1.0.1';
my $NAME = 'reformator ';
my $HELP = '

Script for reformat systemd unit-files (or other ini-like files)

USAGE:

   reformator.pl < example.service

or

  cat example.service | reformator.pl

OPTIONS:

    -d / --delimeter <STR> -- set delimeter to STR (default - "=")
    -s / --spacer <STR> -- set spacer to STR (default - " " - one space)
    -t / --topic <STR> -- set topic to STR (default - "#")
    -c / --comment <STR> -- set comment to STR (default - "#")
    -a / --after <INT> -- set number of fill symbols after (on right) delimeter symbol
    -b / --before <INT> -- set number of fill symbols before (on left) delimeter symbol


    -h / --help -- print help
    -v / --version -- print version
  ';

my $after = 1;
my $before = 1;
my $version_flag = undef;
my $help_flag = undef;

my (@output, @string, @input);
my $topic = "#";
my $comment = "#";
my $delimeter = "=";
my $spacer = " ";
my $final_string = "";
my $fill_string = "";
my $current = 0;
my $maximum = 0;
my $counter = 0;

GetOptions (
    "after=i" => \$after,
    "before=i" => \$before,
    "delimeter=s" => \$delimeter,
    "spacer=s" => \$spacer,
    "topic=s" => \$topic,
    "comment=s" => \$comment,
    "version" => \$version_flag,
    "help" => \$help_flag
    ) or die ("Error in command line arguments!\n");

if (defined ($version_flag)) {
    say $NAME . $VERSION;
    exit 0;
}

if (defined ($help_flag)) {
    say $HELP;
    exit 0;
}

if ($after < 0) {
    say "--after value must be >= 0";
    exit 1;
}

if ($before < 0) {
    say "--before value must be >= 0";
    exit 1;
}

if ($delimeter =~ m/^$/) {
    say "--delimeter value must be non-empty";
    exit 1;
}

if ($spacer =~ m/^$/) {
    say "--spacer value must be non-empty";
    exit 1;
}

if ($topic =~ m/^$/) {
    say "--topic value must be non-empty";
    exit 1;
}

if ($comment =~ m/^$/) {
    say "--comment value must be non-empty";
    exit 1;
}


$output[0] = $topic;

while (<STDIN>) {
    chomp;
    if ($_ =~ m/^$/) {
        next;
    } elsif ($_ =~ m/^$comment/) {
        next;
    } elsif ($_ =~ m/^\s*$/) {
        next;
    } else {
        push(@input,$_);
    }
}

foreach (@input) {
 
    if ($_ =~ m/\[/) {
        next;
    }
 
    @string = split($delimeter, $_, 2);
    $current = length($string[0]);

    if ($current > $maximum) {
        $maximum = $current;
    }

    @string = "";
}

$current = 0;

foreach (@input) {
 
    if ($_ =~ m/\[/) {
        push(@output, $_);
        next;
    }

    @string = split($delimeter, $_, 2);
    $current = length($string[0]);
 
    until ($counter == ($maximum - $current + $after + $before) ) {
        $fill_string = $fill_string . $spacer;
        $counter++;
    }

    if ($string[1] =~ m/^\-/) {
        $final_string = $string[0] . $fill_string . $delimeter . $string[1];
    } else {
        $final_string = $string[0] . $fill_string . $delimeter . $spacer . $string[1];
    }

    push(@output, $final_string);
    $counter = 0;
    $fill_string = "";
}

foreach (@output) {
 
    if ($_ =~ m/\[/) {
        say "";
    }
    say $_;
}

say "";

exit 0;
