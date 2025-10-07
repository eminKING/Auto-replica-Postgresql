#!/bin/bash

echo "What do you want to create?"
echo "1) Master"
echo "2) Replica"
read -p "Enter number (1 or 2): " choice

if [ "$choice" == "1" ]; then
    echo "Starting master..."
    docker-compose -f docker-compose.master.yml up -d

    ip=$(hostname -I | awk '{print $1}')
    echo "✅ Master started!"
    echo "Use this IP for your replica: $ip"

elif [ "$choice" == "2" ]; then
    read -p "Enter master IP address: " master_ip

    # Replace text MASTER_IP_PLACEHOLDER with user IP in config file
    sed -i "s/MASTER_IP/$master_ip/g" replica/docker-compose.replica.yml

    echo "Starting replica..."
    docker-compose -f docker-compose.replica.yml up -d
    echo "✅ Replica started and connected to $master_ip"

else
    echo "❌ Wrong number. Please type 1 or 2."
fi
