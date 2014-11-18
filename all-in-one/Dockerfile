# Klocwork klocwork server component
FROM ubuntu:14.04
MAINTAINER Larry Edelstein <ladelstein@gmail.com>

RUN useradd klocwork \
    && echo "klocwork:klocwork" | chpasswd \
    && apt-get update -y \
    && apt-get install -y lib32tinfo5 \
    && apt-get install -y libaio1 \
    && mkdir -p /home/klocwork \
    && chown klocwork:klocwork /home/klocwork

WORKDIR /home/klocwork

ADD klocwork_installer.sh /home/klocwork/klocwork_installer.sh
RUN chmod 755 klocwork_installer.sh

ADD klocwork.lic /home/klocwork/klocwork.lic
RUN chmod 755 klocwork.lic

RUN su klocwork -c "./klocwork_installer.sh -a server KlocworkServer LicenseServer" \
    && su klocwork -c "mkdir -p server/projects_root/licenses" \
    && su klocwork -c "cp klocwork.lic server/projects_root/licenses"

CMD su klocwork -c "server/bin/kwservice -r server/projects_root start" \
    && su klocwork -c "tail -f server/projects_root/logs/klocwork.log"
