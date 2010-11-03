use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;

all_from 'lib/Text/Tera.pm';


test_requires 'Test::More' => '0.88';

auto_set_repository;

tests_recursive;
author_tests 'xt';


clean_files qw(
    Text-Tera-*
    *.stackdump
    cover_db *.gcov *.gcda *.gcno
    nytprof
    *.out
);

WriteAll(check_nmake => 0);
