package logger::XmlFileParser;
=head1 NAME
logger::XmlFileParser

=head1 DESCRIPTION 
Original file: XmlFileParser.pm
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
our @EXPORT_OK   = qw(processXml);

use XML::LibXML;

=item C<processLog>

############################################################
processLog

process a file of logEntries using the $parser and $decoder given

=cut

sub processXml
{
    my ($inputfile, $reader) = @_;
    
    # get the current time #
    my $now = time;    
    
    my ($lineCount, $parsedCount) = (0, 0);

    # Common parser.
    my $parser = XML::LibXML->new();

    # Read the master file
    my $dom  = $parser->parse_file($inputfile);
    my $root = $dom->getDocumentElement;

    $parsedCount += $reader->parse($root);
    $reader->close();

    my $warningsCount = $reader->reportWarnings();
    if ($warningsCount > 0) {
        print "\nPlease report these issues to EMSD.VNX.CE.DEV.ENABLEMENT.CI\@emc.com\n";
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
