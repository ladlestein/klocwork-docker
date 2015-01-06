# Klocwork all-in-one
FROM ubuntu:14.04
MAINTAINER Larry Edelstein <ladelstein@gmail.com>

RUN useradd klocwork \
    && echo "klocwork:klocwork" | chpasswd \
    && apt-get update -y \
    && apt-get install -y lib32tinfo5 libaio1 \
    && apt-get install -y openssh-server supervisor \
    && mkdir -p /home/klocwork /var/run/sshd /var/log/supervisor \
    && chown klocwork:klocwork /home/klocwork

WORKDIR /home/klocwork

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD klocwork_installer.sh /home/klocwork/klocwork_installer.sh
RUN chmod 755 klocwork_installer.sh

# Should EXPOSE 8080 here, right?

EXPOSE 22 8080 27000

ADD klocwork.lic /home/klocwork/klocwork.lic
RUN chmod 755 klocwork.lic

WORKDIR /home/klocwork

RUN su klocwork -c "./klocwork_installer.sh -a server KlocworkServer LicenseServer BuildTools"

#CMD ["/usr/bin/supervisord"]
CMD /usr/sbin/sshd \
    && su klocwork -c "if [ ! -e /opt/klocwork/projects_root/config ]; then server/bin/kwservice setup -r /opt/klocwork/projects_root; fi" \
    && su klocwork -c "cp klocwork.lic /opt/klocwork/projects_root/licenses" \
    && su klocwork -c "server/bin/kwservice -r /opt/klocwork/projects_root start" \
    && tail -f /opt/klocwork/projects_root/logs/klocwork.log