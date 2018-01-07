package utilities::compare;         
=head1 NAME
utilities::compare

=head1 DESCRIPTION 
Original file: compare.pm


The following methods are provided:
C<compareRefs>

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
our @EXPORT_OK   = qw(compareRefs compareHostNames);

use Data::Dumper;
use utilities::Constants qw(:constants);

=item C<compareRefs>

############################################################
compareRefs

compare contents of 2 refs

=cut

sub compareRefs
{
  my ($ref1, $ref2) = @_;
  local $Data::Dumper::Terse    = 1;
  local $Data::Dumper::Indent   = 0;
  local $Data::Dumper::Sortkeys = 1;

  my $ref1Dump = Dumper($ref1);
  my $ref2Dump = Dumper($ref2);

  my $ret = $ref1Dump eq $ref2Dump;
  if (not $ret)
  {
    print "$ref1Dump != $ref2Dump";
  }
  return $ret;
}

=item C<compareHostNames>

############################################################
compareHostNames

compare contents of 2 host names and return true or false

=cut

sub compareHostNames
{
  my ($host1, $host2) = @_;
  
  return (( $host1 =~ /^$host2$/i ) or ( $host1 =~ /^$host2\./i ) or ( $host2 =~ /^$host1\./i ) ) ? TRUE : FALSE;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut
