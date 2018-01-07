package utilities::DataDump;

=head1 NAME
utilities::DataDump

=head1 DESCRIPTION 
Original file: DataDump.pm

This software dumps out a #ref as a JSON file

=head1 AUTHOR
Bob Ballantyne  2017/06/24

=head1 

########################################################################

=head2 Methods

=over 12

=cut

use strict;
use warnings;

use Exporter;
our $VERSION     = 1.00;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(dumpAsJSON, dumpModuleList);

use JSON;
use Scalar::Util qw(reftype);
use utilities::array qw(deepCopyArray);
use utilities::hashes qw(deepCopyHash);


sub dumpAsJSON
{
  my $data = shift;
  return unless (ref $data);
  if (reftype($data) eq 'ARRAY') {
    $data = deepCopyArray($data) unless (ref($data) eq 'ARRAY');
  }
  elsif (reftype($data) eq 'HASH') {
    $data = deepCopyHash($data) unless (ref($data) eq 'HASH');
  }
  
  my $file = shift;
  $file = './dataDump.json' unless (defined $file);

  my $HTML;
  open($HTML, '>', $file) or die "Unable to open '${file}'. Failed with error : $!"; 
  select $HTML; 
  print '"Data Dump":'. to_json( $data , {utf8 => 1, pretty => 1, allow_unknown => 1} ); 
  select STDOUT;
}

sub dumpModuleList()
{
    my @modules = ();
    my @paths = sort { length($b) <=> length($a) } @INC;
    foreach my $pkg ( sort values %INC ) {
      my $path = '';
      foreach ( @paths ) {
         if (substr($pkg, 0, length($_)) eq $_) {
            $pkg = substr($pkg, length($_)+1);
            $path = $_;
            last;
         }
      }
      $pkg =~ s|.pm$||;
      $pkg =~ s|/|::|g;
      my $ver = (defined $pkg->VERSION ) ? $pkg->VERSION : 'undef';
      push @modules, { "$pkg" => [ $ver, $path ] };
    }
    dumpAsJSON (\@modules, 'modules.lst');
}
1;