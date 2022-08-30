FROM openjdk:11-jre-slim

ARG kafka_version=3.2.1
ARG scala_version=2.13
# ARG vcs_ref=unspecified
ARG build_date=unspecified
ARG use_zookeeper=

LABEL org.label-schema.name="kafka" \
      org.label-schema.description="Apache Kafka" \
      org.label-schema.build-date="${build_date}" \
      org.label-schema.vcs-url="https://github.com/dearmai/kafka-docker" \
      # org.label-schema.vcs-ref="${vcs_ref}" \
      org.label-schema.version="${scala_version}_${kafka_version}" \
      org.label-schema.schema-version="1.0" \
      maintainer="Rinjae"

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/app/kafka \
    USE_ZOOKEEPER=${use_zookeeper}

ENV PATH=${PATH}:${KAFKA_HOME}/bin

RUN set -eux ; 
RUN apt-get update ;
RUN apt-get upgrade -y ;
RUN apt-get install -y --no-install-recommends jq net-tools curl wget ;
RUN sync ; 
RUN mkdir /app; cd /app
COPY download-kafka.sh start.sh /app/
RUN chmod a+x /app/*.sh ; 
WORKDIR /app
RUN /bin/sh -c /app/download-kafka.sh
RUN tar xfz /app/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /app ; 
RUN rm /app/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz ; 
RUN mv /app/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} ; 
RUN rm -rf /var/lib/apt/lists/*

#CMD ["tail", "-f", "/dev/null"]
#CMD ["start-kafka.sh"]
WORKDIR /app
# CMD ["kafka-server-start.sh", "config/server.properties"]
CMD ["./start.sh"]