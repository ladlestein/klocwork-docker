FROM ladlestein/jenkins-slave:latest
MAINTAINER Larry Edelstein <ladlestein@gmail.com>

USER root

RUN useradd klocwork \
    && echo "klocwork:klocwork" | chpasswd \
    && apt-get update -y \
    && apt-get install -y lib32tinfo5 \
    && apt-get install -y build-essential \
    && mkdir -p /home/klocwork \
    && chown klocwork:klocwork /home/klocwork

WORKDIR /home/klocwork

ADD klocwork_installer.sh /home/klocwork/klocwork_installer.sh
ADD klocwork.lic /home/klocwork/klocwork.lic

RUN chmod 755 klocwork_installer.sh \
    && chmod 755 klocwork.lic \
    && su klocwork -c "./klocwork_installer.sh -a client BuildTools" \
    && su klocwork -c "mkdir -p server/projects_root/licenses" \
    && su klocwork -c "cp klocwork.lic server/projects_root/licenses"

USER jenkins