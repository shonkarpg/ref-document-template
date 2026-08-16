#!/bin/bash

# ==============================
# Configuration
# ==============================
HOSTED_ZONE_ID="Z343394117JIKE14Z4IAB"
ZONE_NAME="abc.tech"
BACKUP_DIR="/root/scripts/route53/sync-with-s3"
S3_BUCKET="s3://abc-backup/route53-backup/abc.tech"
AWS_PROFILE="default"     # change if required
AWS_REGION="us-east-1"    # Route53 is global but CLI still needs a region

# ==============================
# Date & Timestamp
# ==============================
DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# ==============================
# Create Backup Directory
# ==============================
mkdir -p "$BACKUP_DIR/$DATE"
#BACKUP_FILE="$BACKUP_DIR/$DATE/route53_${ZONE_NAME}_${TIMESTAMP}.json"
BACKUP_FILE="$BACKUP_DIR/route53_${ZONE_NAME}_${TIMESTAMP}.json"

# ==============================
# Take Route53 Backup
# ==============================
aws route53 list-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json > "$BACKUP_FILE"

# ==============================
# Verify Backup
# ==============================
if [ -s "$BACKUP_FILE" ]; then
  echo "✅ Route53 backup created: $BACKUP_FILE"
else
  echo "❌ Backup failed or empty file"
  exit 1
fi

# ==============================
# Sync to S3
# ==============================
aws s3 sync "$BACKUP_DIR" "$S3_BUCKET" --profile "$AWS_PROFILE" --region "$AWS_REGION" --storage-class STANDARD_IA

# ==============================
# Log Success
# ==============================
echo "☁️ Backup synced to S3: $S3_BUCKET"

# ==============================
# Cleanup older backup, -mtime +10 → files older than 10 days
# ==============================
find /root/scripts/route53/sync-with-s3 -type f -mtime +10 -delete
echo "========================Done=========================="
