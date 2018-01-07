package utilities::readfile;

=head1 NAME
utilities::readfile

=head1 DESCRIPTION 
Original file: readfile.pm


The following methods are provided:
C<readText>  C<readLinesOfText>  C<readBinary>  C<readJson>


=head1 AUTHOR
Bob Ballantyne  2015/05/01

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use warnings;
use strict;
use File::Basename;
use JSON;
#use utilities::hashes qw(deepCopyHash);


our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(readText readLinesOfText readBinary readJson writeJson getName);
our $VERSION   = 1.00;

use constant
{
    BINARY        => 2,
    LINESOFTEXT   => 1,
    TEXT          => 0
};
our %EXPORT_TAGS = (MODE => [ 'TEXT', 'LINESOFTEXT', 'BINARY' ] );

=item C<readText>

############################################################
readText


=cut

sub readText
{
    my ($ref) = @_;
    return _readFile(getName($ref), TEXT);
}

=item C<readLinesOfText>

############################################################
readLinesOfText


=cut

sub readLinesOfText
{
    my ($ref) = @_;
    return _readFile(getName($ref), LINESOFTEXT);
}

=item C<readBinary>

############################################################
readBinary


=cut

sub readBinary
{
    my ($ref) = @_;
    return _readFile(getName($ref), BINARY);
}

=item C<readJson>

############################################################
readJson


=cut

sub readJson
{
    my ($ref) = @_;
    my $json = _readFile(getName($ref), BINARY);
    return JSON->new->utf8->decode( $json );
}

=item C<writeJson>

############################################################
writeJson


=cut

sub writeJson
{
    my ($ref, $hash) = @_;
    open(FILE, '>', getName($ref)) or return;
    print FILE JSON->new->utf8->pretty->encode(utilities::hashes::deepCopyHash($hash)); 
    close FILE;
}
#########################################################################

sub getName
{
    my $ref = shift;

    return $ref unless (ref($ref) eq 'HASH');

    # take directory of test source and prepend file name of test data 
    return dirname($ref->{'ref'}) . $ref->{name};
}

sub _readFile
{
    my ($fileName, $mode) = @_;
    
    $mode = 0    if (!defined $mode);
    my $retVal = undef;
    if (defined $fileName  && -e $fileName)
    {
        open(FILE, '<', $fileName) or return $retVal;
        if ($mode == LINESOFTEXT)
        {
            my @lines;
            while (<FILE>) {
              push @lines, $_;
            }
            chomp(@lines);
            $retVal = \@lines;
        }
        else
        {
            my $filesize = -s $fileName;
            read(FILE, $retVal, $filesize);
            chomp($retVal)  if ($mode != BINARY);
        }
        CORE::close FILE;
    }
    return $retVal;
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut
