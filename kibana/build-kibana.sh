#!/bin/bash
sh docker build --build-arg ELASTIC_VERSION=7.9.2 --build-arg WAZUH_VERSION=3.13.2 -t wazuh_kibana:3.13.2_7.9.2 .