package utilities::string;         
=head1 NAME
utilities::string

=head1 DESCRIPTION 
Original file: string.pm


The following methods are provided:
C<trim>

=head1 AUTHOR
Bob Ballantyne  2015/01/08

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(trim);


=item C<trim>

############################################################
trim

return a string with no leading/trainiing white space

=cut

sub trim {
  my $string = shift;
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  return $string;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut