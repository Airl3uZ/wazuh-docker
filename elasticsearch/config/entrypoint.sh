#!/bin/bash
bin/elasticsearch-plugin install --batch https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-s3/repository-s3-${ES_VERSION}.zip

exec /usr/local/bin/docker-entrypoint.sh elasticsearch