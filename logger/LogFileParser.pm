package logger::LogFileParser;
=head1 NAME
logger::LogFileParser

=head1 DESCRIPTION
Original file: LogFileParser.pm
This software parses a given file. Each line of the file has a logEntry


The following methods are provided:
C<processLog>   C<decode>

=head1 AUTHOR
Bob Ballantyne  2014/11/02

=head1 SEE ALSO


########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;
use Exporter;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(processLog decode);


=item C<processLog>

############################################################
processLog

process a file of logEntries using the $parser and $decoder given

=cut

sub processLog
{
    my ($inputfile, $parser, $maxlines) = @_;

    # get the current time #
    my $now = time;

    my ($lineCount, $parsedCount) = (0, 0);
    open(FILE, '<:utf8', $inputfile) or die ("FATAL: Failed to open($inputfile) for parsing:$!\n");
    while (<FILE>) {
      $lineCount++;
      $parsedCount += $parser->parse($_);
      last  if (defined($maxlines) &&  $parsedCount >= $maxlines);
    }
    close(FILE);
    $parser->close();

    my $warningsCount = $parser->reportWarnings();
    if ($warningsCount > 0) {
        print "\nPlease report these issues\n";
    }

    # print summary of what was done #
    print "\n\nParsed ".$parsedCount.' lines out of '.$lineCount." lines read";
    print '.    '.$warningsCount.' warnings detected '  if ($warningsCount > 0);

    # Calculate total runtime (current time minus start time) #
    $now = time - $now;
    # Print runtime #
    printf("\nTotal running time: %02d:%02d:%02d\n\n", int($now / 3600), int(($now % 3600) / 60), int($now % 60));

    return 1;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut