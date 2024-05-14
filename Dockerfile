FROM aflplusplus/aflplusplus:latest as builder

RUN apt update && apt install libdb5.3-dev libssl-dev libgnutls28-dev libfile-fcntllock-perl -fy

RUN useradd -ms /bin/bash exim

COPY . /exim

RUN mkdir /exim/src/Local

COPY local /exim/src/Local/Makefile

ENV EXIM_RELEASE_VERSION fuzzable

RUN make -C /exim/src && make -C /exim/src install

RUN mkdir /inputs

COPY seed /inputs/

COPY dictionary.txt /dictionary.txt

CMD ["afl-fuzz", "-i", "/inputs", "-o", "/output", "-x", "/dictionary.txt", "-t", "5000", "-m", "none", "-Q", "--", "/exim/src/build-Linux-x86_64/exim", "-bs", "-v"]

