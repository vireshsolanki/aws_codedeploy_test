#!/bin/bash

# Change permissions of the deployed files
echo "Changing permissions of deployed files..."
cd ..
sudo chmod +x clear_cache.sh change_permissions.sh restart_nginx.sh
