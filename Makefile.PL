#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'MooseX::Types::Set::Object',
	VERSION_FROM => 'lib/MooseX/Types/Set/Object.pm',
	INSTALLDIRS  => 'site',
	SIGN         => 1,
	PL_FILES     => { },
	PREREQ_PM    => {
		'Moose'           => '0.50', # class_type
		'Set::Object'     => 0,
		'MooseX::Types'   => 0,
		'Test::use::ok'   => 0,
		'Test::Exception' => 0,
	},
);

