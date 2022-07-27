FROM mcr.microsoft.com/vscode/devcontainers/universal

RUN cd /tmp \
    && curl -L https://git.musl-libc.org/cgit/musl/snapshot/musl-1.2.2.tar.gz > musl-1.2.2.tar.gz \
    && tar -xf musl-1.2.2.tar.gz \
    && cd musl-1.2.2 \
    && ./configure \
    && make \
    && sudo make install > /dev/null 2>&1
