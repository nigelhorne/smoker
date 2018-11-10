FROM debian
COPY perl-5.29.3-smoker.setup /tmp/setup
RUN bash /tmp/setup && rm /tmp/setup

RUN useradd -ms /bin/bash smoker
USER smoker
WORKDIR /home/smoker

ENV TEST_JOBS 2
ENV HARNESS_OPTIONS c:j2
EXPOSE 21214:21214/udp

RUN mkdir -p .cpanreporter .cpan/CPAN
COPY config.ini .cpanreporter/config.ini
COPY MyConfig.pm .cpan/CPAN/MyConfig.pm
COPY perl-5.29.3-smoker.build build
RUN bash build && rm build

ENV PATH $PATH::
CMD ["/bin/bash", "-c", "source perl5/perlbrew/etc/bashrc && perlbrew use perl-5.29.3 && cd smoker/bin && PATH=$PATH:: ./smokerdaemon -p 21214"]
