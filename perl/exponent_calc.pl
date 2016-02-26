#!/usr/bin/env perl

use strict;
use warnings;

use constant DEFAULT_MAX_VAL => 1000;

use bigint;

my ( $base, $divisor, $max_value ) = @ARGV;

print_help() if grep { $_ =~ /^-([h?]|-help)$/ } @ARGV; # check for -? -h --help
print_help() unless is_int($base);       # args[0] must be an integer
print_help() unless is_int($divisor);    # args[1] must be an integer
     # args[2] is optional, but it must be an integer if provided

$max_value = DEFAULT_MAX_VAL if not defined $max_value;
print_help() unless is_int($max_value);

my $criteria = <<"EOF";
  1 <= i <= $max_value
  1 <= ( $base ^ i  ) <= $max_value
  ( $base ^ i  ) divisible by $divisor
EOF

my (@values);
for my $multiple ( 1 .. $max_value ) {
  my $exponent = $base**$multiple;
  last if $exponent > $max_value;
  next if $exponent % $divisor;
  push @values, $exponent;
}

my $how_many = scalar @values ? scalar @values : "No";
my $plural   = @values == 1 ? "value" : "values";
print {*STDERR} "$how_many $plural satisfied the criteria:\n$criteria\n";

if ( not @values ) {
  exit 1;
} 

print join q[, ], @values;
print "\n";
exit 0;

sub is_int { defined $_[0] and $_[0] =~ /\A\d+\z/ }

sub print_help {
  print {*STDERR} <<"EOF";
Usage:
  exponent_calc.pl EXPONENT_BASE EXPONENT_DIVISOR (MAX_VAL=1000)
Will print all values of
  EXPONENT_BASE ^ i where EXPONENT_BASE ^ I divisible by EXPONENT_DIVISOR
Between
  1 and MAX_VAL
EOF
  exit 1;
}
