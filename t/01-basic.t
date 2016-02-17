use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Badge::Depot::Plugin::Perl;

my $badge = Badge::Depot::Plugin::Perl->new(version => '5.10');

is $badge->to_html,
   '<img src="https://img.shields.io/badge/perl-5.10-blue.svg" alt="Requires Perl 5.10" />', 'Correct html';

done_testing;
