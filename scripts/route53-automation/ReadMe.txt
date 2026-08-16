make sure following IAM role attached to ec2
IAM role policy- update-route53

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListHostedZonesByName",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "*"
        }
    ]
}

-------------------------------------------------


 crontab -l
@reboot /root/scripts/update_dns.sh