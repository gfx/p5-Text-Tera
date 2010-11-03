#!perl -w
use strict;
use Test::More tests => 2;

BEGIN {
    use_ok 'Text::Tera';
    use_ok 'Text::Tera::Parser';
}

diag "Testing Text::Tera/$Text::Tera::VERSION";
