#!/bin/bash
if [ $1 = "config" ]; then
sudo nano /var/www/automne_core/freq.json
else
echo "Command unknown"
fi
