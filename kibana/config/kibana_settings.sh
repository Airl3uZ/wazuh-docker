#!/bin/bash
# Wazuh Docker Copyright (C) 2020 Wazuh Inc. (License GPLv2)

WAZUH_MAJOR=3

curl_auth="--cacert ${CERTS_DIR}/ca/ca.crt -u $ELASTICSEARCH_USERNAME:$ELASTICSEARCH_PASSWORD"

while [[ "$(curl $curl_auth -XGET -I  -s -o /dev/null -w ''%{http_code}'' https://$SERVER_NAME:5601/status)" != "200" ]]; do
  echo "Waiting for Kibana API. Sleeping 5 seconds"
  sleep 5
done

# Prepare index selection.
echo "Kibana API is running"

default_index="/tmp/default_index.json"

cat > ${default_index} << EOF
{
  "changes": {
    "defaultIndex": "wazuh-alerts-${WAZUH_MAJOR}.x-*"
  }
}
EOF

sleep 5
# Add the wazuh alerts index as default.
curl -POST ${curl_auth} "https://$SERVER_NAME:5601/api/kibana/settings" -H "Content-Type: application/json" -H "kbn-xsrf: true" -d@${default_index}
rm -f ${default_index}

sleep 5
# Configuring Kibana TimePicker.
curl -POST ${curl_auth} "https://$SERVER_NAME:5601/api/kibana/settings" -H "Content-Type: application/json" -H "kbn-xsrf: true" -d \
'{"changes":{"timepicker:timeDefaults":"{\n  \"from\": \"now-24h\",\n  \"to\": \"now\",\n  \"mode\": \"quick\"}"}}'

sleep 5
# Do not ask user to help providing usage statistics to Elastic
curl -POST ${curl_auth} "https://$SERVER_NAME:5601/api/telemetry/v2/optIn" -H "Content-Type: application/json" -H "kbn-xsrf: true" -d '{"enabled":false}'

echo "End settings"
