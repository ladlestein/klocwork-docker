#FROM busybox
FROM ubuntu:14.04
MAINTAINER Larry Edelstein <ladlestein@gmail.com>

RUN useradd -u 1000 jenkins \
  && mkdir -p /var/jenkins_home \
  && chown -R jenkins /var/jenkins_home

#RUN mkdir -p /var/jenkins_home

VOLUME /var/jenkins_home

CMD ["true"]
