package Text::Tera;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use parent qw(Text::Xslate);

sub options {
    my($self) = @_;
    my $opts = $self->SUPER::options;

    $opts->{syntax} = 'Text::Tera::Parser';
    return $opts;
}

1;
__END__

=head1 NAME

Text::Tera - Jinja compatible template engine on Xslate

=head1 VERSION

This document describes Text::Tera version 0.01.

=head1 SYNOPSIS

    use Text::Tera;

    my $tera = Text::Tera->new();

    print $tera->render_string("Hello, {% lang %} world!\n",
        {
            lang => 'Tera',
        }
    ); # => Hello, Tera world!

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<Text::Xslate> - a scalable template engine for Perl5

L<http://jinja.pocoo.org/> - a modern and designer friendly templating language for Python

=head1 AUTHOR

gfx E<lt>gfuji@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010, gfx. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
