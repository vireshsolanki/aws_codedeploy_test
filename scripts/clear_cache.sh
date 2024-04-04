#!/bin/bash

# Clear any cached data or temporary files
# echo "Clearing cache and temporary files..."
# sudo rm -rf /var/www/html/*
sudo yum remove amazon-cloudwatch-agent.x86_64 -y
sudo rm -rf /opt/*
