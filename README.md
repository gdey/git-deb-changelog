Objective
======================================================================

The purpose of this script is to generate debian changelog files from git log.
To enable this we are going to create some simple conventions. These convetions
will allow us to know which message to include from which commits into the 
changelog file. 

Debian Changelog
-----------------------------------

For this discussion the changelog will be the debian changelog, as describe 
[here][debcl].


      package (version) distribution(s); urgency=urgency
          [optional blank line(s), stripped]
       * change details
         more change details
          [blank line(s), included in output of dpkg-parsechangelog]
       * even more change details
          [optional blank line(s), stripped]
      -- maintainer name <email address>[two spaces]  date


The date field will be an [RFC 5322][rfc5322] date.


Git and GitNotes
-----------------------------------

This system will be a bit different from other system, in that it will generate
the changelog everytime. The changelog will be generated from notes stored in the
git repository. These notes themselfs will be generated from the git logs, and 
parsing them to generate the actually changelog entries which will be stored
as notes in git. Since there are various complications git using [git notes][gitnotes] from
multiple people we only be using the automated process to do such things.

Git Log and supported elements
-----------------------------------

  When the system is looking through the logs it will search for the following
items. These items will then formated to fit into the above format. The version
number will be take from previous note and have the minor version updated, and the
patch number updated for each commit between the current position and last note.
The major number will not get updated unless the marker ([major changelog|bug|fixed|enh]) is 
included in at least on of the commit messages.  Versioning will infromation for 
this tries to follow [Semantic Versioning][semver].

This will hold true unless a shell script called version.sh exists in the debain 
directory; which will be responsiable for providing the version number. 

If the current HEAD already has a note then the [debian\_revision][debver] should be 
incremented by one. 

The log will look for the following elements and each of these elements are 
expected to be begin with'[' ']' optionally followed by a '(' the url of the issue,
followed by '):' and then an optional message. Line can be continued by using 
a '\' followed by any number of spaces and then newline (\n). 

An example message would look like:

    [Fixed](trello://q1dBcgW0): Fixed URL to better show the page.
    [Changelog]: The software is now 2x better. Also, there this great new \  
                 feature that I would like to tell you about.

The basic format is:

   '['[Major]' '(Fixed|Issue|Bug|Changelog)']''('$URI')'':'$MESSAGE

These are the terms the software currently supports:
(*Note these are all case insensitive*)

   * Fixed     -- Indicates a fix for a bug or and issue.
   * Issue     -- Indicates a fix or something to do with the issue.
   * Bug       -- Indicates a fix or something related to the bug.
   * changelog -- Add addition information on wants to log in the change log file 
   
Defintaion of a URI
-----------------------------------

  This is just a uri as defined by [RFC 3986][rfc3986]. The software will support
  the following protocols:
  
  * http://  -- http://www.example.com
      for http urls.
  * trello:// -- trello://q1dBcgW0
      for trello cards the will convert the url to: 
           http://trello.com/c/$uri_path
  * ghpull:// -- ghpull://tealium/utui#9999
      for github pull requests; this will be converted to:
          http://github.com/tealium/utui/pull/9999
  * commit:// -- commit://c1bea400a4
      for referencing commits, this will be resolved to a remote if it can
      be.


Examples:
-----------------------------------

Given the following Log messages from git:

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

We would expect the following changelog entry to be generated:
    
    example-package (0.1.0-0) stable; urgency=normal

      * commit: 1dfe0a351a1004a7884cbdd4986eadad15d56a04
         * (http://trello.com/c/23giwylk4) Fixed issue with date not doing the right thing when
           the month is close to the end. 
         * Also added new feature that allows us to jump the moon. 
      -- Gautam Dey <gautam.dey77@gmail.com> 

      * commit: 164b748b4e013be93407d60a54cb01ed3b27d54
        * (http://github.com/gdey/foo/pull/12) Exit when rabbit restarts. 
      -- Gautam Dey <gautam.dey77@gmail.com> 

    -- Package Build Bot <PBB@gautamdey.info>  Mon, 30 Jul 2013 04:00:00 +0000

    
[debcl]: http://www.debian.org/doc/debian-policy/ch-source.html "Debian Changelog"
[semver]: http://semver.org/spec/v2.0.0-rc.2.html "Semantic Versioning"
[rfc3986]: http://www.faqs.org/rfcs/rfc3986.html "RFC 3986"
[rfc5322]: http://www.faqs.org/rfcs/rfc5322.html "RFC 5322"
[gitnotes]: http://git-scm.com/2010/08/25/notes.html "Git Notes"
[debianver]: http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version "Debian Versioning"
