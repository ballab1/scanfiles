package utilities::object;

=head1 NAME
utilities::compare

=head1 DESCRIPTION 
Original file: object.pm


The following methods are provided:
C<compareRefs>

=head1 AUTHOR
Edwin Jacques  2015/02/12

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;
use Exporter qw(import);
use utilities::hashes qw(copyHash);
use logger::ExitLogger;
use logger::Errors qw(:errors );

our $VERSION   = 1.00;
our @EXPORT_OK = qw(initObject);

=item C<compareRefs>

############################################################
initObject

Initialize an object a hash of key=>value parameters.
Check for required parameters ('log' and 'exitLogger' are 
required).
Report an error on exit.

Returns a blessed self.

=cut

sub initObject
{
  my $class = shift;
  my $params = shift;
  my @required = @_;

  my $self = {};
  bless( $self, $class );
  
  # always require log and exitLogger;
  push(@required, 'log', 'exitLogger');

  # setup default values
  copyHash( $params, $self );

  # verify we have all of the keys we need
  for my $required (@required)
  {
    if ( not exists $self->{$required} )
    {
      my $errorMessage = "$class initialization missing parameter: $required"; 
      my $exitLogger = $self->{exitLogger};
      if ( defined $exitLogger )
      {
        $exitLogger->exitWithAdditionalMessage( MISSING_PARAMETER, $errorMessage);
      }
      else
      {
        die "$errorMessage. (ExitLogger not defined.)";
      }
    }
  }

  return $self;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut
