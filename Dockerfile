FROM buildpack-deps:bionic-scm

RUN apt-get update && apt-get install build-essential -y

ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        fontconfig \
	unzip \
	openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /root/.gradle

ENV MAVEN_VERSION 3.3.3

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

ENV NODE_VERSION 6.9.2
ENV NPM_VERSION 3.10.9

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear
    
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.4
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version
