FROM ubuntu:16.04

ENV VERSION 1.4
ENV WEB_VERSION 0.5.10

RUN apt-get update && apt-get install -y wget && apt-get clean

RUN mkdir /arachni && \
	wget -qO- https://github.com/Arachni/arachni/releases/download/v${VERSION}/arachni-${VERSION}-${WEB_VERSION}-linux-x86_64.tar.gz | tar xvz -C /arachni --strip-components=1

WORKDIR /arachni
EXPOSE 9292

## Jenkins Swarm ##
RUN apt-get install default-jdk -y && \
    wget http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar 
ENV TINI_SHA ea87ac5a900b646a197ecbf10fe71bb927433958
RUN apt-get install curl -y
RUN curl -fL https://github.com/krallin/tini/releases/download/v0.6.0/tini-static -o /bin/tini && chmod +x /bin/tini && \
    echo "$TINI_SHA /bin/tini" | sha1sum -c -
COPY jenkins-swarm.sh /usr/local/bin/jenkins-swarm.sh
RUN chmod +x /usr/local/bin/jenkins-swarm.sh

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins-swarm.sh"]
