package utilities::formattime;

=head1 NAME
utilities::formattime

=head1 DESCRIPTION 
Original file: formattime.pm


The following methods are provided:
C<compareRefs>

=head1 AUTHOR
Bob Ballantyne  2015/05/01

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;
use Exporter qw(import);

our @EXPORT_OK = qw(getTime);
our $VERSION   = 1.00;

=item C<getTime>

############################################################
getTime


=cut

sub getTime
{
    my $tmVal = shift;
    
    return undef    if (! defined($tmVal));
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime( $tmVal );
    $year += 1900;
    $mon++;
    return sprintf("%02d/%02d/%04d %02d:%02d:%02d", $mon, $mday, $year, $hour, $min, $sec);
}

#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut
