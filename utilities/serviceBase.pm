package utilities::serviceBase;

=head1 NAME
utilities::serviceBase

=head1 DESCRIPTION 
Original file: serviceBase.pm


The following methods are provided:

=head1 AUTHOR
Bob Ballantyne  2015/01/23

=head1 SEE ALSO

########################################################################

=head2 Methods

=over 12

=cut

use strict;
use warnings;
use Exporter 'import';
our $VERSION = 1.00;

use logger::Errors qw(:errors );
use logger::ExitLogger;
use logger::Log;
use utilities::RunCli;
use utilities::hashes qw(copyHash);


my @mandatoryServices = ('services');

=item C<new>

############################################################
constructor

my $obj = utilities::serviceBase->new()


=cut
sub new
{
    my ( $class, $params, @neededServices ) = @_;

    my $self = {};
    bless( $self, $class );

    # add all the passed params to ourself
    copyHash($params, $self)  if (defined $params);  


    # verify we have all the services needed
    my @requiredServices = @mandatoryServices;
    push (@requiredServices, @neededServices)   if (scalar @neededServices > 0);
    for my $required ( @requiredServices )
    {
        if ( not defined $self->{$required} )
        {
            print STDERR "Needed Parameter '$required' has not been defined for $class.\n";
            print STDOUT "Needed Parameter '$required' has not been defined for $class.\n";
            $self->exit(MISSING_PARAMETER);
        }
    }
    return $self;
}

#########################################################################
sub getService
{
    my ( $self, $serviceName, $params ) = @_;
    
    # special case services
    return $self->{'log'} if $serviceName eq 'log';
    return $self->{'exitLogger'} if $serviceName eq 'exitLogger';
    return $self->{'runCli'} if $serviceName eq 'runCli';
    return $self->{'services'} if $serviceName eq 'services';

    # check 'asked for service' is available
    return undef unless exists $self->{services}->{$serviceName};

    # setup $params for service call
    $params = {}                                    unless defined $params;
    $params->{'services'} = $self->{'services'}     unless exists $params->{'services'};

    # add these for backward compatibility
    $params->{'log'} = $self->{'log'}               unless exists $params->{'log'};
    $params->{'exitLogger'} = $self->{'exitLogger'} unless exists $params->{'exitLogger'};
    $params->{'runCli'} = $self->{'runCli'}         unless exists $params->{'runCli'};

    #handle service
    my $pkg = $self->{'services'}->{$serviceName};
    return undef unless defined $pkg;
#    return $pkg($params)  if Scalar::Utilities::reftype($pkg) eq 'CODE';
    return $pkg->new($params);
}

#########################################################################
sub printInfo
{
    my ( $self, @params ) = @_;
    $self->{'log'}->printInfo(@params);
}

#########################################################################
sub exit
{
    my ( $self, @params ) = @_;
    $self->{'exitLogger'}->exitWithMessage(@params);
}

#########################################################################
sub runCli
{
    my ( $self, @params ) = @_;
    $self->{'runCli'}->run(@params);
    return $self->{'runCli'};
}
#########################################################################
1;
__END__

=back

=head1 EXAMPLES

Show how we use this module

=cut
