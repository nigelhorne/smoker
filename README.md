smoker
======

# GETTING STARTED

If you've never run a CPAN smoke tester before, read http://cpanwiki.grango.org/wiki/GettingStarted.

On FreeBSD as root:

    pkgin install p5-Sys-CpuLoad p5-CPAN-Reporter p5-Proc-ProcessTable p5-JSON p5-LWP-Protocol-https sudo curl wget bash lynx ncftp mozilla-rootcerts git rsync p5-MIME-Lite perl
    mozilla-rootcerts install

On all systems:

Download and install perlbrew from http://perlbrew.pl.

# WITHOUT DOCKER

For each version of perl that you wish to smoke test:

    perlbrew install -j4 perl-5.28.1
    perlbrew use perl-5.28.1
    cpan -i Test::Reporter::Transport::Metabase CPAN::Reporter Net::SSLeay LWP::Protocol::https
    bin/loadall1
    bin/loadall2
    bin/loadall3
    bin/loadall5

Ensure that the .../bin files are in your PATH.

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

# WITH DOCKER

I use Docker images so that I can isolate several smokers running once.
You'll see that I use /mnt/CPAN as an NFS point for the CPAN modules,
you'll probably want to change that to your local CPAN mirror.
If you don't have a local mirror, this option isn't for you since
there's no other notification method to tell the smokers in the containers
what's been published and is ready for smoking.

To build an image

    # test perl 5.28.1 listening for CPAN modules on port 21213
    cd dockerprojects
    ./docker-build-image 5.28.1 21213

To run an image

    docker run --log-driver syslog --log-opt syslog-address=udp://loghost:42185 -dt --name perl-5.28.1-smoker --mount type=bind,src=/mnt/CPAN,dst=/mnt/CPAN,readonly -p 0.0.0.0:21213:21213/udp perl-5.28.1-smoker
