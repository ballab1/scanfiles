package logger::CsvLogger;         
=head1 NAME
logger::CsvLogger

=head1 DESCRIPTION 
Original file: CsvLogger.pm
This software outputs records to a CSV file


The following methods are provided:
C<new>  C<header>   C<close>   C<logger>

=head1 COPYRIGHT
(C) 2013 - 2014 EMC

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
use Encode qw(encode);
use IO::Handle;

our $VERSION     = '1.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(close header logger);

use constant {
    NAME => 0,
    IS_STRING => 1   
};

# auto-flush IO
IO::Handle::autoflush(1);

=item C<new>

############################################################
constructor

my $log = unity::logger::CsvLogger->new($filename, \@columnDefs)

The constructor returns a new C<unity::common::CsvLogger> object which 
will output records to a CSV file

=cut

sub new
{
  my ( $class, $fileName, $columnNames) = @_;

  my $self = {};
  bless( $self, $class );

  # setup default values
  die("FATAL: No columns defined!\n")  if (not defined $columnNames  or  scalar @{ $columnNames } == 0);
  $self->{columnNames} = $columnNames;

  die("FATAL: No filename defined!\n")  if (not defined $fileName  or  length($fileName) == 0);
  open ($self->{FILE}, '>', $fileName)   or die("FATAL: Failed to open($fileName) for logging:$!\n");
  $self->{headerWritten} = 0;
  $self->{lines} = 0;
 
  return $self;
}


=item C<header>

############################################################
header

   $log->header()

print a the header record

=cut

sub header
{
    my ($self) = @_;
    $self->{headerWritten} = 1;
    
    my $FILE = $self->{FILE};
    my $x = 0;
    for my $comp (@{ $self->{columnNames} }) {
        print $FILE ","                  if ($x != 0);
        print $FILE "$comp->[NAME]";
        $x++;
    }
    print $FILE "\n";
    $self->{lines}++;
}


=item C<close>

############################################################
close

   $log->close()

close a CsvLogger file

=cut

sub close
{
    my ($self) = @_;
    my $FILE = $self->{FILE};
    close($FILE);
    $self->{headerWritten} = 0;
}


=item C<logger>

############################################################
logger

   $log->logger()

outputs a record to a CSV file

=cut

sub logger
{
    my ($self, $results) = @_;

    $self->header()  if ($self->{headerWritten} == 0);
    
    my $FILE = $self->{FILE};
    my $x = 0;
    for my $comp (@{ $self->{columnNames} }) {
      my $name = $comp->[NAME];
      my $is_string = $comp->[IS_STRING];
        print $FILE ","                     if ($x != 0);
        if (defined $results->{$name}) {
            my $val = $results->{$name};
            if ($is_string == 1) {
                $val =~ s/\\/\\\\/g;
                $val =~ s/"/\\"/g;
                $val =~ s/\n/\\n/g;
                $val = '"' . encode('utf8', $val) . '"'  if (length($val) > 0);
                
            }
            print $FILE $val;
        }
        $x++;
    }
    print $FILE "\n";
    $self->{lines}++;
}


#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut