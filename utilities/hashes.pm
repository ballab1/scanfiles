package utilities::hashes;
=head1 NAME
utilities::hashes

=head1 DESCRIPTION 
Original file: hashes.pm


The following methods are provided:
C<copyHash>   C<deepCopyHash>

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
use utilities::array qw(copyArray deepCopyArray);

our $VERSION = '1.01';
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(copyHash deepCopyHash);

=item C<copyHash>

############################################################
copyHash

create a new copy of a hash

=cut
sub copyHash
{
    my ($src, $dst) = @_;
    
    return undef if(Scalar::Util::reftype($src) ne 'HASH');
    $dst = {}  if (! defined $dst );
    foreach ( keys %{ $src } )
    {
        $dst->{$_} = $src->{$_};
    }
    return $dst;
}
=item C<deepCopyHash>

############################################################
deepCopyHash

create a new copy of a hash

=cut
sub deepCopyHash
{
    my ($src, $dst) = @_;
    
    return undef if(Scalar::Util::reftype($src) ne 'HASH');
    $dst = {}  if (! defined $dst );
    foreach ( keys %{ $src } )
    {
        my $val = $src->{$_};
        if(ref($val) eq 'ARRAY')
        {
            $dst->{$_} = deepCopyArray($val);
        }
        elsif(ref($src->{$_}) eq 'HASH')
        {
            $dst->{$_} = deepCopyHash($val); 
        }
        else
        {
            $dst->{$_} = $val;
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