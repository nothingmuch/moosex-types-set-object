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

=pod

=head1 NAME

MooseX::Types::Set::Object - Set::Object type with coercions and stuff.

=head1 SYNOPSIS

	package Foo;
	use Moose;

	use MooseX::Types::Set::Object;

	has children => (
		isa      => "Set::Object",
		accessor => "transition_set",
		coerce   => 1, # also accept array refs
		handles  => {
			children     => "members",
			add_child    => "insert",
			remove_child => "remove",
			# See Set::Object for all the methods you could delegate
		},
	);

	# ...

	my $foo = Foo->new( children => [ @objects ] );

	$foo->add_child( $obj );

=head1 DESCRIPTION

This module provides Moose type constraints (see
L<Moose::Util::TypeConstraints>, L<MooseX::Types>).

=head1 TYPES

=over 4

=item Set::Object

A subtype of C<Object> that isa L<Set::Object> with coercions to and from the
C<ArrayRef> type.

=back

=head1 SEE ALSO

L<Set::Object>, L<MooseX::AttributeHandlers>, L<MooseX::Types>,
L<Moose::Util::TypeConstraints>

=head1 VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
L<http://nothingmuch.woobling.org/code>, and use C<darcs send> to commit
changes.

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=head1 COPYRIGHT

	Copyright (c) 2008 Yuval Kogman. All rights reserved
	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=cut
