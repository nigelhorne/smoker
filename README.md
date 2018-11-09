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

# DOCKER

I use Docker images so that I can isolate several smokers running once.
You'll see that I use /mnt/CPAN as an NFS point for the CPAN modules,
you'll probably want to change that.

To build an image

    cd dockerprojects
    bash -e perl-5.29.3-smoker.install

To run an image

    run "docker run --log-driver syslog --log-opt syslog-address=udp://loghost:42185 -dt --name perl-5.29.3-smoker --mount type=bind,src=/mnt/CPAN,dst=/mnt/CPAN,readonly perl-5.29.3-smoker
