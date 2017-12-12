smoker
======

Yet another mini-smoker for Perl.

    smoker - run a Perl smoker on the latest CPAN uploads on the current Perl

    -i - interactive, see what's going on

    smokerloop - shell wrapper to run smoker on all perlbrew installations

OR:

    smokerupdate - update a local minicpan repositary and broadcast the updates
    	Run this out of cron
    smokerdaemon - listen to smokerupdates and test the updates
    	Start this in the systems where you're going to test CPAN modules

# APPARMOR

I'm testing the use of Apparmor to stop programs from creating files all over
the place - a number of test programs create in my home directory for example.

Here's what I have at the moment in
/etc/apparmor.d/home.njh.src.njh.smoker.bin:

   #include <tunables/global>
   /home/njh/src/njh/smoker/bin {
   	audit deny @{HOME}/** rw,
	audit deny /usr/bin/sudo rwx,
    }

I then ran

    apparmor_parser -a /etc/apparmor.d/home.njh.src.njh.smoker.bin
    systemctl reload apparmor

This is experimental.
