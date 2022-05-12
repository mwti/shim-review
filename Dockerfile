FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y git build-essential make gnu-efi libelf-dev efitools efibootmgr bsdmainutils wget 

RUN mkdir /git
WORKDIR /git
RUN git clone https://github.com/rhboot/shim.git /git/shim
RUN git clone https://github.com/mwti/rescueshim.git /git/rescueshim
WORKDIR /git
RUN cp rescueshim/sbat.csv shim/data/
WORKDIR /git/shim
RUN make update
RUN make 'DEFAULT_LOADER=\\\\grubx64.efi' VENDOR_CERT_FILE="/git/rescueshim/etoken.der" LIBDIR=/usr/lib > makelog.txt 2>&1

WORKDIR /git
RUN hexdump -Cv shim/shimx64.efi > shim.build.dump.txt
RUN hexdump -Cv rescueshim/shimx64.efi > shim.repo.dump.txt
RUN diff -u shim.build.dump.txt shim.repo.dump.txt

