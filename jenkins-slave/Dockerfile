FROM ubuntu:14.04
MAINTAINER Larry Edelstein <ladlestein@gmail.com>

RUN useradd -u 102 jenkins \
  && echo "jenkins:jenkins" | chpasswd \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    git \
    openssh-server \
    openjdk-7-jdk \
  && mkdir -p /var/run/sshd \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /home/jenkins \
  && chown 102:106 /home/jenkins

WORKDIR /home/jenkins

USER jenkins

ADD slave.jar /home/jenkins/slave.jar

EXPOSE 22

CMD java -jar /home/jenkins/slave.jar -jnlpUrl http://master:8080/computer/kwslave/slave-agent.jnlp