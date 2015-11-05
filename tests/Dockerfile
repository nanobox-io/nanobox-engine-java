FROM nanobox/build:beta

# Remove existing engines, we don't want to test those
RUN rm -rf /opt/engines/*

# Create folders for this engine
RUN mkdir -p /opt/engines/java/bin && \
    mkdir -p /opt/engines/java/lib && \
    mkdir -p /opt/engines/java/templates && \
    mkdir -p /opt/tests/sample-java

RUN curl https://codeload.github.com/nanobox-io/nanobox-engine-nodejs/tar.gz/master | \
    tar -xzC /opt/engines/java --strip-components 1

# Add in this engine's files
ADD bin/. /opt/engines/java/bin
ADD lib/. /opt/engines/java/lib
ADD templates/. /opt/engines/java/templates
ADD tests/sample-java/src/. /opt/tests/sample-java