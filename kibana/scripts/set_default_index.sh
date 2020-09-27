#!/bin/bash

WAZUH_MAJOR=3
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
curl -POST "http://localhost:5601/api/kibana/settings" -H "Content-Type: application/json" -H "kbn-xsrf: true" -d@${default_index}
rm -f ${default_index}

sleep 5
# Configuring Kibana TimePicker.
curl -POST "http://localhost:5601/api/kibana/settings" -H "Content-Type: application/json" -H "kbn-xsrf: true" -d \
'{"changes":{"timepicker:timeDefaults":"{\n  \"from\": \"now-24h\",\n  \"to\": \"now\",\n  \"mode\": \"quick\"}"}}'
