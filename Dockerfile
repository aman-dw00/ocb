FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install specific Java version (match what JMX scraper expects)
RUN apt-get update && apt-get install -y \
    openjdk-11-jre-headless \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set explicit JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Copy your custom collector
COPY ./build/otelcol-jmx /otelcol-jmx

# Copy JMX scraper jar
COPY opentelemetry-jmx-scraper.jar /otel/opentelemetry-jmx-scraper.jar

# Copy config
COPY ./otel-config.yaml /etc/otel/otel-config.yaml

ENTRYPOINT ["/otelcol-jmx", "--config", "/etc/otel/otel-config.yaml"]