FROM jenkins:1.583
MAINTAINER Matt Smith <mtscout6@gmail.com>

USER root

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $JENKINS_HOME/plugins \
  && wget -O $JENKINS_HOME/plugins/git.hpi https://updates.jenkins-ci.org/latest/git.hpi \
  && wget -O $JENKINS_HOME/plugins/git-client.hpi https://updates.jenkins-ci.org/latest/git-client.hpi

USER jenkins
