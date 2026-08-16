#!/bin/bash

# -----------------------------
# Variables - EDIT THESE FIRST
# -----------------------------
HOSTED_ZONE_ID="Z343394117JIKE14Z4IAB"      # Your Route53 hosted zone ID
RECORD_NAME="wiki.abc.tech"     # DNS record to update
TTL=300                               # TTL for the record

# -----------------------------
# Fetch public IP
# -----------------------------
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

if [[ -z "$PUBLIC_IP" ]]; then
    echo "Error: Unable to fetch public IP"
    exit 1
fi

echo "Public IP found: $PUBLIC_IP"

# -----------------------------
# Create JSON for Route53 UPSERT
# -----------------------------
cat > /tmp/route53-changes.json << EOF
{
  "Comment": "Update A record for Jenkins",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${RECORD_NAME}",
        "Type": "A",
        "TTL": ${TTL},
        "ResourceRecords": [
          { "Value": "${PUBLIC_IP}" }
        ]
      }
    }
  ]
}
EOF

# -----------------------------
# Update Route53 Record
# -----------------------------
echo "Updating Route53 record..."

aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch file:///tmp/route53-changes.json

if [[ $? -eq 0 ]]; then
    echo "Successfully updated Route53 A record for ${RECORD_NAME} → ${PUBLIC_IP}"
else
    echo "Failed to update Route53 record."
    exit 1
fi
