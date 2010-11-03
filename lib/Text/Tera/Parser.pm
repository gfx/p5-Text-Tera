package Text::Tera::Parser;
use Any::Moose;
extends qw(Text::Xslate::Parser);

sub _build_line_start { '#' }
sub _build_tag_start  { '{%' }
sub _build_tag_end    { '%}' }

sub _build_identity_pattern {
    return qr{ [a-zA-Z_][a-zA-Z0-9_]* }xms;
}

# preprocess code sections
around trim_code => sub {
    my($super, $parser, $code) = @_;

    # comment {# ... #}
    if($code =~ /\A \# .* \# \z/xms) {
        return '';
    }

    return $parser->$super($code);
};

sub init_symbols {
    my($parser) = @_;
    my $s;

    $parser->init_basic_operators();

    $parser->symbol('endif')   ->is_block_end(1);
    $parser->symbol('elif')    ->is_block_end(1);
    $parser->symbol('endfor')  ->is_block_end(1);
    $parser->symbol('endblock')->is_block_end(1);

    $parser->symbol('in');

    $parser->symbol('if') ->set_std(\&std_if);
    $parser->symbol('for')->set_std(\&std_for);

    $parser->symbol('extends')->set_std($parser->can('std_cascade'));

    $parser->symbol('include')->set_std($parser->can('std_include'));

    return;
}

sub std_if {
    my($parser, $symbol) = @_;

    my $if = $symbol->clone(arity => 'if');

    my $cond = $parser->expression(0);

    if($parser->token->id eq ":") { # optional ':'
        $parser->advance();
    }

    $if->first($cond);

    $if->second( $parser->statements() );
    my $t = $parser->token;

    my $top_if = $if;

    while($t->id eq "elif") {
        $parser->reserve($t);
        $parser->advance(); # "elif"

        my $elsif = $t->clone(arity => "if");
        $elsif->first(  $parser->expression(0) );
        $elsif->second( $parser->statements() );
        $if->third([$elsif]);
        $if = $elsif;
        $t  = $parser->token;
    }

    if($t->id eq 'else') {
        $parser->reserve($t);
        $t = $parser->advance();

        $if->third( $parser->statements() );
    }

    $parser->advance('endif');
    return $top_if;
}

sub default_nud {
    my($parser, $symbol) = @_;
    return $symbol->clone(arity => 'variable');
}

sub undefined_name {
    my($parser, $name) = @_;
    # undefined names are always variables
    return $parser->symbol_table->{'(variable)'}->clone(
        id => $name,
    );
}

sub is_valid_field {
    my($parser, $token) = @_;
    return $parser->SUPER::is_valid_field($token)
        || $token->arity eq "variable";
}

sub std_for {
    my($parser, $symbol) = @_;

    my $proc = $symbol->clone(arity => "for");

    my $var = $parser->token;
    if($var->arity ne "variable") {
        $parser->_unexpected("a variable name", $var);
    }
    $parser->advance();
    $parser->advance("in");
    $proc->first( $parser->expression(0) );
    $proc->second([$var]);
    $parser->new_scope();
    $parser->define_iterator($var);
    $proc->third( $parser->statements() );
    $parser->advance("endfor");
    $parser->pop_scope();
    return $proc;
}


no Any::Moose;
__PACKAGE__->meta->make_immutable();

