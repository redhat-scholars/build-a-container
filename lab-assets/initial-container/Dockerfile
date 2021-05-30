
# Build an apache server that will run as root and is compatible with the
# httpd that is installed below
FROM registry.access.redhat.com/ubi7 as builder
USER root
COPY httpd-2.4.46.tar.bz2 /tmp/httpd-2.4.46.tar.bz2
WORKDIR /tmp
RUN yum install -y make bzip2 apr-devel apr-util-devel gcc pcre-devel
RUN bzip2 -c --decompress httpd-2.4.46.tar.bz2 | tar -xvf -
RUN cd httpd-2.4.46 && \
    export CFLAGS="-DBIG_SECURITY_HOLE" && \
    ./configure --prefix="/etc/httpd" --with-suexec-bin="/usr/sbin/suexec" --with-mpm=prefork --enable-mpms-shared="prefork" && \
    make 

FROM registry.access.redhat.com/ubi7 as final
USER root
# install apache (and tree to be able to demonstrate issues easier)
RUN yum install -y httpd && yum update -y && rpm -i https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/tree-1.6.0-10.el7.x86_64.rpm && yum clean all

# shellshock vulnerability
COPY bash-4.2.45-2.el7.x86_64.rpm /tmp
RUN yum downgrade -y /tmp/bash-4.2.45-2.el7.x86_64.rpm && rm /tmp/bash-4.2.45-2.el7.x86_64.rpm

COPY httpd.conf /etc/httpd/conf
COPY --chmod=755 log-visitor.sh /var/www/cgi-bin
COPY hello.html /var/www/html
# The initial directory the visitor log will be written to
RUN mkdir -p /var/log/www && chown 0:0 /var/log/www

## overwrite the two parts of the httpd install that make running as root possible
COPY --from=builder --chown=0:0 /tmp/httpd-2.4.46/httpd /usr/sbin/httpd
COPY --from=builder --chown=0:0 /tmp/httpd-2.4.46/modules/arch/unix/.libs/mod_unixd.so /etc/httpd/modules/mod_unixd.so

# CMD python3 -m http.server --bind 0.0.0.0 --cgi 8000

CMD /usr/sbin/httpd -DFOREGROUND