# Wazuh Docker Copyright (C) 2020 Wazuh Inc. (License GPLv2)
################################################################################
# Build stage 0 `builder`:
# Extract Kibana plugin
################################################################################

FROM docker.elastic.co/kibana/kibana:7.9.3 as builder

USER kibana
ARG ELASTIC_VERSION=7.9.3
ARG WAZUH_VERSION=4.0.3
ARG WAZUH_APP_VERSION="${WAZUH_VERSION}_${ELASTIC_VERSION}"

WORKDIR /usr/share/kibana
RUN bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-${WAZUH_APP_VERSION}-1.zip
RUN mv /usr/share/kibana/plugins/wazuh /tmp/wazuh

################################################################################
# Build stage 1 (the actual Kibana image):
#
# Copy kibana from stage 0
# Add entrypoint
################################################################################
FROM docker.elastic.co/kibana/kibana:7.9.3
LABEL maintainer="siriwat.jiws@gmail.com"
COPY --from=builder --chown=1000:0 /tmp/wazuh /usr/share/kibana/plugins/wazuh
USER root
# Add an init process, check the checksum to make sure it's a match
RUN curl -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.4/dumb-init_1.2.4_x86_64
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "cd7ab5513d20f4b985012d264fbdee60ccd2ea528b94b4b9308c6c6d26f8ba90  /usr/local/bin/dumb-init" | sha256sum -c -

WORKDIR /
COPY --chown=1000:0 ./config/welcome_wazuh.sh ./config/entrypoint.sh ./config/wazuh_app_config.sh ./config/kibana_settings.sh ./
COPY --chown=1000:0 ./config/custom_welcome /tmp/custom_welcome
RUN chmod +x /*.sh \
    && chmod +x /usr/local/bin/dumb-init \
    && ./welcome_wazuh.sh
ARG CHANGE_WELCOME="true"
COPY --chown=kibana:kibana ./config/wazuh.yml /usr/share/kibana/optimize/wazuh/config/wazuh.yml
WORKDIR /

ENV PATTERN="" \
    CHECKS_PATTERN="" \
    CHECKS_TEMPLATE="" \
    CHECKS_API="" \
    CHECKS_SETUP="" \
    EXTENSIONS_PCI="" \
    EXTENSIONS_GDPR="" \
    EXTENSIONS_HIPAA="" \
    EXTENSIONS_NIST="" \
    EXTENSIONS_TSC="" \
    EXTENSIONS_AUDIT="" \
    EXTENSIONS_OSCAP="" \
    EXTENSIONS_CISCAT="" \
    EXTENSIONS_AWS="" \
    EXTENSIONS_GCP="" \
    EXTENSIONS_VIRUSTOTAL="" \
    EXTENSIONS_OSQUERY="" \
    EXTENSIONS_DOCKER="" \
    APP_TIMEOUT="" \
    API_SELECTOR="" \
    IP_SELECTOR="" \
    IP_IGNORE="" \
    WAZUH_MONITORING_ENABLED="" \
    WAZUH_MONITORING_FREQUENCY="" \
    WAZUH_MONITORING_SHARDS="" \
    WAZUH_MONITORING_REPLICAS="" \
    ADMIN_PRIVILEGES=""

USER kibana
WORKDIR /usr/share/kibana
RUN NODE_OPTIONS="--max-old-space-size=2048" /usr/local/bin/kibana-docker --optimize

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
