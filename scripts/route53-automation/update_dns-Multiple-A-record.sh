#!/bin/bash

# Route53 Multi-Record Updater - JSON Fixed
HOSTED_ZONE_ID="Z343394117JIKE14Z4IAB"
TTL=300
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

RECORDS=("*.abc.tech" "xyz.abc.tech" "123.abc.tech")

[ -z "$PUBLIC_IP" ] && { echo "❌ No IP"; exit 1; }
echo "🌐 IP: $PUBLIC_IP"

# -----------------------------
# Generate VALID JSON (key fix)
# -----------------------------
JSON_FILE="/tmp/route53-changes.json"

cat > "$JSON_FILE" << 'EOF'
{
  "Comment": "Multi-record IP update",
  "Changes": [
EOF

# Add records safely
for i in "${!RECORDS[@]}"; do
    if [ $i -eq 0 ]; then
        COMMA=""
    else
        COMMA=","
    fi
    
    cat >> "$JSON_FILE" << EOF
${COMMA}
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${RECORDS[$i]}",
        "Type": "A", 
        "TTL": $TTL,
        "ResourceRecords": [{"Value": "$PUBLIC_IP"}]
      }
    }
EOF
done

# Proper JSON close
cat >> "$JSON_FILE" << 'EOF'
  ]
}
EOF

# -----------------------------
# Validate JSON
# -----------------------------
echo "📄 Validating JSON..."
python3 -m json.tool "$JSON_FILE" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ JSON Invalid. Raw content:"
    cat "$JSON_FILE"
    exit 1
fi

echo "✅ JSON Valid ✓"

# -----------------------------
# Update Route53
# -----------------------------
aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch "file://$JSON_FILE"

if [ $? -eq 0 ]; then
    echo "✅ SUCCESS: ${#RECORDS[@]} records updated"
    rm -f "$JSON_FILE"
else
    echo "❌ Route53 API failed"
    echo "Debug JSON:"
    cat "$JSON_FILE"
    exit 1
fi
