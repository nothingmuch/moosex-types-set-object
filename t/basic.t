#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

use ok 'MooseX::Types::Set::Object';

{
	package Blah;
	use Moose;

	has stuff => (
		isa => "Set::Object",
		is  => "rw",
		coerce => 1,
	);

	has junk => (
		isa => "Set::Object",
		is  => "rw",
	);

	has misc => (
		isa => "Set::Object[Foo]",
		is  => "rw",
		coerce => 1,
	);

	package Foo;
	use Moose;

	package Bar;
	use Moose;
	
	extends qw(Foo);

	package Gorch;
	use Moose;
}

my @objs = (
	"foo",
	Foo->new,
	[ ],
);

my $obj = Blah->new( stuff => \@objs );

isa_ok( $obj->stuff, "Set::Object" );
is( $obj->stuff->size, 3, "three items" );

foreach my $item ( @objs ) {
	ok( $obj->stuff->includes($item), "'$item' is in the set");
}

throws_ok { Blah->new( junk => [ ] ) } qr/type.*Set::Object/i, "fails without coercion";

throws_ok { Blah->new( junk => \@objs ) } qr/type.*Set::Object/i, "fails without coercion";


{
	local $TODO = "coercion for parametrized types seems borked";
	lives_ok { Blah->new( misc => [ ] ) } "doesn't fail with empty array for parametrized set type";
}

lives_ok { Blah->new( misc => Set::Object->new ) } "doesn't fail with empty set for parametrized set type";

throws_ok { Blah->new( misc => \@objs ) } qr/Foo/, "fails on parametrized set type";

throws_ok { Blah->new( misc => Set::Object->new(\@objs) ) } qr/Foo/, "fails on parametrized set type";

{
	local $TODO = "coercion for parametrized types seems borked";
	lives_ok { Blah->new( misc => [ Foo->new, Bar->new ] ) } "no error on coercion from array filled with the right type";
}

lives_ok { Blah->new( misc => Set::Object->new([ Foo->new, Bar->new ]) ) } "no error with set filled with the right type";
throws_ok { Blah->new( misc => Set::Object->new([ Foo->new, Gorch->new, Bar->new ]) ) } qr/Foo/, "error with set that has a naughty object";
