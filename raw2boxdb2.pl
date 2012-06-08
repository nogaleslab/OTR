#!/usr/bin/perl -w
#
# Version: 0.3, 121809
#
# purpose:	Transfer particle coordinates from xmipp format (.raw) to Boxer.
#
# description:	Takes as input 
#
# author:       Slaton Lipscomb <slaton@ocf.berkeley.edu> & Michael Cianfrocco (2010)
#
# usage:	spi2boxdb -b BOXSIZE -i FILE -o FILE [-d] -s image Size of micrograph
#
# todo:		1) replace spaces with tabs in output
#
use Getopt::Long;
use Text::Tabs;

my $input;		# input spi file
my $output;		# output box file
my $boxsize;		# particle boxsize (pixels)
my $field5 = -3;	# field 5 constant in Box DB format
my $debug = 0;		# boolean flag
my @fields;		# array of SPIDER registers parsed from each line
my $xcoord;
my $ycoord;
my $imageSize;
$tabstop = 8;


GetOptions("i=s" => \$input,			# string
		"o=s" => \$output,		# string
		"b=s" => \$boxsize,		# string
		"s=s" => \$imageSize,		# string
		"debug" => \$debug);		# flag 

if (!$input || !$output) { usage() }

if ($debug) {			# print values of all parameters
	print "input = $input\n";
	print "output = $output\n";
	print "boxsize = $boxsize\n";
	print "imageSize = $imageSize\n";
	print "debug = $debug\n";
}

if ($ARGV[0]) {
	print "$0: Unknown option(s) unprocessed by Getopt::Long\n";
	foreach (@ARGV) {
		print "$_\n";
	}
	exit 1;
}

if ($debug) { print "Parsing SPIDER data from $input\n" }

## open spi file for reading & box file for writing
#print unexpand (
open (SPIFILE, "$input") || die "Can't open input SPIDER file `$input`: $!";
open (BOXFILE, ">$output") || die "Can't open output Box DB file `$output`$!";

## line by line, read & parse box file and write out spi file
while (defined ($line = <SPIFILE>)) {
	chomp ($line);		# remove endline

	$line =~ s/^\s+//;	# delete leading whitespace
	$line =~ s/\s+$//;	# delete trailing whitespace

	print " -> trimmed line is \"$line\"\n" if $debug;

	if (substr($line,0,1) eq "#") {	# if comment skip this line
		print " --> skipped comment \"$line\"\n" if $debug;
		next;
	}
	
	@fields = split(/\s+/, $line);  # split by whitespace 

	if ($debug) {
		print " --> newline";
		foreach $x (@fields) { print " ---> field = \"$x\"\n" }
	}

	$half = $boxsize / 2;

	$xcoord = sprintf("%-10.0f", $fields[0]-$half);	# 10 digits, no sig figs, align left
	$ycoord = sprintf("%-10.0f", $fields[1]-$half);

	print " -> xcoord  = \"$xcoord\"\n"," -> ycoord  = \"$ycoord\"\n" if $debug; 
	
	write (BOXFILE);
}
close (BOXFILE) || die "Couldn't close Box DB file `$input`: $!";

exit 0;

##
## print usage & quit
##
sub usage {
	print <<END;
Usage: spi2boxdb -b BOXSIZE -i FILE -o FILE [-d]

Transfer particle coordinates from a SPIDER document file (.spi) to a Boxer
Box DB file (.box).


Required arguments: 
    -b BOXSIZE	your particle boxsize in pixels
    -i FILE	read SPIDER input from FILE 
    -o FILE	write Box DB output to FILE

END
exit 1;
} 

format BOXFILE =
@<<<<<< @<<<<<< @<<<<<< @<<<<<< @>
$xcoord, $ycoord, $boxsize, $boxsize, $field5
.
