use inc::Module::Install;
name 'Plack-Middleware-DBIx-QueryLog';
all_from 'lib/Plack/Middleware/DBIx/QueryLog.pm';

requires 'Plack::Middleware';
requires 'DBIx::QueryLog';
requires 'Text::ASCIITable';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
