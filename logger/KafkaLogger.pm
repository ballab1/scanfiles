package logger::KafkaLogger;         
=head1 NAME
logger::KafkaLogger

=head1 DESCRIPTION 
Original file: KafkaLogger.pm
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
use JSON;
use Kafka::Librd;

our $VERSION     = '1.00';
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(close logger);


=item C<new>

############################################################
constructor

my $log = unity::logger::CsvLogger->new($filename, \@columnDefs)

The constructor returns a new C<unity::common::CsvLogger> object which 
will output records to a CSV file

=cut

sub new
{
  my ( $class, $server, $topic) = @_;

  my $self = {};
  bless( $self, $class );

  die("FATAL: No topic defined!\n")  if (not defined $topic  or  length($topic) == 0);

  $self->{kafka} = Kafka::Librd->new(Kafka::Librd::RD_KAFKA_PRODUCER,
                                       { "client.id" => $client_id,
                                         "group.id" => $consumer_id,
                                         "default_topic_conf" => "topic_conf"}
                                     );

  $self->{lines} = 0;
 
  return $self;
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
    my $kafka = $self->{kafka};
    $kafka->destroy;
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
    
    my $kafka = $self->{kafka};
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
            $err = $kafka->commit_message($msg, $async)
            print $FILE $val;
        }
        $x++;
    }
    $self->{lines}++;
}


#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut