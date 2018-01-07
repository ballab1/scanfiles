package utilities::array;
=head1 NAME
utilities::array

=head1 DESCRIPTION 
Original file: array.pm


The following methods are provided:
C<copyArray>   C<deepCopyArray>

=head1 AUTHOR
Bob Ballantyne  2015/01/08

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;

use Exporter;
use Scalar::Util;
use utilities::hashes qw(copyHash deepCopyHash);

our $VERSION = 1.01;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(copyArray deepCopyArray);

=item C<copyArray>

############################################################
copyArray

make a true copy of an array reference

=cut

sub copyArray
{
    my ($src, $dst) = @_;

    return undef if(Scalar::Util::reftype($src) ne 'ARRAY');
    $dst = []  if (not defined $dst );
    foreach ( @{ $src } )
    {
        push @{ $dst }, $_;
    }
    return $dst;
}
=item C<copyArray>

############################################################
deepCopyArray

make a true copy of an array reference

=cut

sub deepCopyArray
{
    my ($src, $dst) = @_;

    return undef if(Scalar::Util::reftype($src) ne 'ARRAY');

    $dst = []  if (not defined $dst );
    foreach ( @{ $src } )
    {
        if(Scalar::Util::reftype($_) eq 'ARRAY')
        {
            push @{ $dst }, deepCopyArray($_);
        }
        elsif(Scalar::Util::reftype($_) eq 'HASH')
        {
            push @{ $dst }, deepCopyHash($_); 
        }
        else
        {
            push @{ $dst }, $_;
        }
    }
    return $dst;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut