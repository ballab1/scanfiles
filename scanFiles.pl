#!/usr/bin/perl
#
# Original file: parseLog.pl
#
# $Verion 1.0  $0 2015/01/09  - Bob Ballantyne $


use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin";
use ArgHandler;
use Parser;


#-- GLOBALS -------------------------------------------------------

# get the command line values & other default params
my $argHash = ArgHandler->new( Parser::CONFIG_DATA );

# create the parser with the necessary loggers
my $parser = Parser->new( $argHash->getParams() );

# process the buildlog
eval {
   processLog($argHash->{'infile'}, $parser);
   print 'Successfully parsed '.$argHash->{'infile'}."\n";
};
if ($@) 
{
      print STDERR $@."\n";
      exit ( -1 );
}
exit ( 0 );
