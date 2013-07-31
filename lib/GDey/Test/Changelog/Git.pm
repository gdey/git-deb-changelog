#===============================================================================
#
#         FILE:  GDey/Test/Changelog/Git.pm
#
#  DESCRIPTION: This is the test file for GDey::Changelog::Git 
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Gautam Dey (gdey), gautam_cpan@deyfamily.org
#      COMPANY:  Tealium Inc.
#      VERSION:  1.0
#      CREATED:  07/30/2013 19:08:23
#     REVISION:  ---
#===============================================================================

use v5.12.0;
use warnings;
package GDey::Test::Changelog::Git.pm v0.1.0;
use base qw(Test::Class);
use Test::Most;

# First let's include the module we are going to be test against.
use GDey::Changelog::Git;

my $fix_commits =<<'COMMIT'
commit 1dfe0a351a1004a7884cbdd4986eadad15d56a04
Author: Gautam Dey <gautam@tealium.com>
Date:   Sun Jul 28 23:11:27 2013 -0700

    [Fixed](trello://23giwylk4) Fixed issue with date not doing the right \
      thing when the month is close to the end.
    [changelog] Also added new feature that allows us to jump the moon.

commit 164bf48b4e0134be93407d60a54cb01ed3b27d54
Merge: a65935f a886ae0
Author: Gautam Dey <gautam.dey77@gmail.com>
Date:   Thu Jul 25 13:52:30 2013 -0700

    Merge pull request #12 from gdey/master

    [Changelog](ghpull://gdey/foo#12):Exit when rabbit restarts.

COMMIT

my @fix_commits = (
      { 
         commit => '1dfe0a351a1004a7884cbdd4986eadad15d56a04'
         , author => 'Gautam Dey <gautam@tealium.com>'
         , date   => 'Sun Jul 28 23:11:27 2013 -0700'
         , body   => '[Fixed](trello://23giwylk4) Fixed issue with date not doing the right thing when the month is close to the end.
    [changelog] Also added new feature that allows us to jump the moon.'
     }
    ,{
         commit => '164bf48b4e0134be93407d60a54cb01ed3b27d54'
         , author => 'Gautam Dey <gautam.dey77@gmail.com>'
         , date   => 'Thu Jul 25 13:52:30 2013 -0700'
         , body   => 'Merge pull request #12 from gdey/master

    [Changelog](ghpull://gdey/foo#12):Exit when rabbit restarts.'
         , merge => ['a65936f','a886ae0']
     }
) ;

my @fix_cl_subentries = (
'   * commit: 1dfe0a351a1004a7884cbdd4986eadad15d56a04
     * (http://trello.com/c/23giwylk4) Fixed issue with date not doing the right thing when
       the month is close to the end. 
     * Also added new feature that allows us to jump the moon. 
   -- Gautam Dey <gautam.dey77@gmail.com>',
'   * commit: 164b748b4e013be93407d60a54cb01ed3b27d54
     * (http://github.com/gdey/foo/pull/12) Exit when rabbit restarts. 
   -- Gautam Dey <gautam.dey77@gmail.com>'
);
my $fix_changelog_entry = <<"ENTRY"
example-package (0.1.0-0) stable; urgency=normal

$fix_cl_subentries[0]

$fix_cl_subentries[1]

-- Package Build Bot <PBB\@gautamdey.info>  Mon, 30 Jul 2013 04:00:00 +0000
ENTRY

sub test_git_log_parse : Test {

      # The first thing we are going to do is test to make sure that we can 
      # parse the log's from git. 

   my @commits = GDey::Changelog::Git->parse_commits($fix_commits);
   is_deeply(\@commits, \@fix_commits , "parse commits works");
}

sub test_changelog_gen : Test {
       # Given a set of commit hashes we generate a block of text that is
       # sutiable for 
       my $time = time();
       my $changelog_entry = GDey::Changelog::Git->changelog_for_commits(
          'package-name' => 'example-package',
          'package-build' => 'Package Build Bot <PBB@gautamdey.info>'
          'package-build-date' => 'Mon, 30 Jul 2013 04:00:00 +0000',
          version       => '0.1.0-0',
          dist          => 'stable',
          urgency       => 'normal',
          commits       => \@fix_commits
       );
       is( $changelog_entry eq  $fix_changelog_entry, 
           'Make sure the entry is what we expect' )
}




__PACKAGE__;


