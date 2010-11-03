#!perl -w
use strict;
use Test::More;

use Text::Tera;

my $tx = Text::Tera->new( cache => 0 );

my %vars = (
    lang => 'Tera',
    list => [qw(foo bar baz)],
);

is $tx->render_string(<<'T', \%vars), "Hello, Tera world!\n";
Hello, {% lang %} world!
T

is $tx->render_string(<<'T', \%vars), "Hello, Tera world!\n";
{% if true -%}
Hello, {% lang %} world!
{% endif -%}
T

is $tx->render_string(<<'T', \%vars), <<'X';
{% for item in list -%}
    {% item %}
{% endfor -%}
T
    foo
    bar
    baz
X


done_testing;
