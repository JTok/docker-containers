### Dockerfile for splunk
### Originally from dmaxwell351/docker-containers
FROM phusion/baseimage:0.9.16
label maintainer="jtok"

ENV HOME /root
ENV SPLUNK_HOME=/opt/splunk
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV SPLUNK_PRODUCT splunk
ENV SPLUNK_VERSION 7.0.2
ENV SPLUNK_BUILD 03bbabbd5c0f
ENV SPLUNK_FILENAME splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz
ENV SPLUNK_BACKUP_DEFAULT_ETC /var/opt/splunk

CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
RUN usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /home nobody && \
    chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# make the "en_US.UTF-8" locale so splunk will be utf-8 enabled by default
RUN apt-get update -q && apt-get install -y --no-install-recommends apt-utils && apt-get install -y locales \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# pdfgen dependency
RUN apt-get update && apt-get install -y libgssapi-krb5-2

RUN apt-get update -q && \
	apt-get install -y wget

# RUN wget -O splunk-7.0.2-03bbabbd5c0f-linux-2.6-amd64.deb "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.2&product=splunk&filename=splunk-7.0.2-03bbabbd5c0f-linux-2.6-amd64.deb&wget=true"
# RUN dpkg -i /splunk-7.0.2-03bbabbd5c0f-linux-2.6-amd64.deb

RUN mkdir -p $SPLUNK_HOME \
  && wget -O /tmp/$SPLUNK_FILENAME https://download.splunk.com/products/$SPLUNK_PRODUCT/releases/$SPLUNK_VERSION/linux/$SPLUNK_FILENAME \
  && tar xzf /tmp/$SPLUNK_FILENAME --strip 1 -C $SPLUNK_HOME \
  && rm /tmp/$SPLUNK_FILENAME \
  && apt-get purge -y --auto-remove wget \
  && mkdir -p $SPLUNK_BACKUP_DEFAULT_ETC \
  && cp -R $SPLUNK_HOME/etc $SPLUNK_BACKUP_DEFAULT_ETC \
  && rm -fR $SPLUNK_HOME/etc \
  && chown -R nobody:users $SPLUNK_HOME \
  && chown -R nobody:users $SPLUNK_BACKUP_DEFAULT_ETC \
  && rm -rf /var/lib/apt/lists/*


### Configure Service Startup
COPY rc.local /etc/rc.local
RUN chmod a+x /etc/rc.local && \
    chown -R nobody:users /opt/splunk

RUN printf "\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1\n" >> $SPLUNK_HOME/etc/splunk-launch.conf

#EXPOSE 8000 8089 9997 514
EXPOSE 8000/tcp 8089/tcp 9997/tcp 514/udp

WORKDIR /opt/splunk

VOLUME ["/opt/splunk/var", "/opt/splunk/etc", "/data", "/license"]

### END
### To make this a persistent container, you must map /opt/splunk/var and /opt/splunk/etc of this container
### to a folder on your host machine.
###
