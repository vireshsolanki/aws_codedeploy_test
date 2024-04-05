
#!/bin/bash
set +x
  
# Create directory to download install file to
mkdir -p /cloudwatch
  
# Download the CloudWatch Agent installer
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm  
# Install the CloudWatch agent
rpm -U ./amazon-cloudwatch-agent.rpm 
  
# Create the CloudWatch agent configuration role
cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/bin/cloudwatch_agent_config.json
{
        "agent": {
                "metrics_collection_interval": 30,
                "run_as_user": "root"
        },
        "metrics": {
                "aggregation_dimensions": [
                        [
                                "InstanceId"
                        ]
                ],
                "append_dimensions": {
                        "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
                        "ImageId": "${aws:ImageId}",
                        "InstanceId": "${aws:InstanceId}",
                        "InstanceType": "${aws:InstanceType}"
                },
                "metrics_collected": {
                        "disk": {
                                "measurement": [
                                        "used_percent"
                                ],
                                "metrics_collection_interval": 30,
                                "resources": [
                                        "*"
                                ]
                        },
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 30
                        }
                }
        }
}
EOF

# Start the CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/cloudwatch_agent_config.json -s