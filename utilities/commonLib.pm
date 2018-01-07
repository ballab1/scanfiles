package utilities::commonLib;

use strict;
use warnings;
use Exporter qw(import);

our $VERSION   = 1.00;

our @EXPORT_OK = qw(commonLib isNotEmpty isEmpty fetchValueOnParameterPreference);
our %EXPORT_TAGS = (libraries =>  \@EXPORT_OK);

# ######################################################################
# isNotEmpty()
#
# Input Parameter:
# parameter to be checked
#
# Checks if the variable passed is defined and not empty.
#
# returns a true if valid.
# ######################################################################
sub isNotEmpty 
{
  my $value = shift;
  
  chomp $value if (defined $value);

  return ( ( defined $value ) and ( $value ne '' ) );
}

# ######################################################################
# isEmpty()
#
# Input Parameter:
# parameter to be checked
#
# Checks if the variable passed was not defined or is empty.
#
# returns a true if not defined or is empty.
# ######################################################################
sub isEmpty 
{
  my $value = shift;

  return ( not isNotEmpty($value) );
}

# ######################################################################
# fetchValueOnParameterPreference()
#
# Input Parameter:
# array of values : The sequence is on the basis of priority
#
# returns the value which is either defined and not empty according to the priority
#
# returns the first value which is defined and not empty otherwise undef
# ######################################################################
sub fetchValueOnParameterPreference 
{
  my $parameters = shift;
  
  for my $parameter (@$parameters)
  {
     return $parameter if (isNotEmpty($parameter));
  }

  return undef;
}

1;