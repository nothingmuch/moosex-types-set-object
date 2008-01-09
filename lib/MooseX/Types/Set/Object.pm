#!/usr/bin/perl

package MooseX::Types::Set::Object;
use base qw(MooseX::Types::Base);

use strict;
use warnings;

use Set::Object ();
use Scalar::Util ();

use MooseX::Types -declare => [qw(Set)];
use MooseX::Types::Moose qw(Object ArrayRef);

foreach my $type ( Set, "Set::Object" ) {
	subtype $type,
		as Object,
		where { $_->isa("Set::Object") },
		optimize_as \&optimized_check;


	coerce $type,
		from ArrayRef,
		via { Set::Object->new(@$_) };

	coerce ArrayRef,
		from $type,
		via { $_->members },
}

sub optimized_check { Scalar::Util::blessed($_[0]) && $_[0]->isa("Set::Object") }

__PACKAGE__

__END__


