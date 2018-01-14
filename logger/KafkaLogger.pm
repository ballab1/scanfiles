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
    my ( $class, $config ) = @_;

    my $self = {};
    bless( $self, $class );

    die("FATAL: No consumer_id defined!\n")  unless (defined $config->{'consumer.id'});
    die("FATAL: No client.id defined!\n")  unless (defined $config->{'client.id'});
    die("FATAL: No partition defined!\n")  unless (defined $config->{'partition'});
    die("FATAL: No msgflags defined!\n")  unless (defined $config->{'msgflags'});


    $self->{partition} = $config->{'partition'};
    $self->{msgflags} = $config->{'msgflags'};
    $self->{key} = $config->{'key'};

    my $params = { 'client.id' => $config->{'client.id'},
                   'group.id' => $config->{'consumer.id'} };
    $params->{'default.topic.conf'} = $config->{'topic.conf'}  if (exists $config->{'topic.conf'});
    
    $self->{kafka} = Kafka::Librd->new(Kafka::Librd::RD_KAFKA_PRODUCER, $params);

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
    $self->{kafka}->destroy;
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
    
    my $json = JSON->new->allow_nonref;
    my $json_text = $json->encode( $results );

    my $kafka = $self->{kafka};
    if ($kafka->produce($self->{partition}, $self->{msgflags}, $json, $self->{key})) {
        $self->{lines}++;
    }
}


#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut