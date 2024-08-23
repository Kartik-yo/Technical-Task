#!/bin/bash

# Function to display top 10 most used applications (CPU and memory)
top_10_apps() {
    echo "Top 10 Most Used Applications:"
    ps aux --sort=-%cpu,-%mem | awk 'NR<=10{print $0}'
}

# Function to display network monitoring details
network_monitoring() {
    echo "Network Monitoring:"
    echo "Concurrent Connections:"
    netstat -tun | grep ESTABLISHED | wc -l
    echo "Packet Drops:"
    netstat -i | grep -v face | awk '{if ($4 > 0 || $8 > 0) print $1, $4, $8}'
    echo "Network Bandwidth Usage:"
    ifstat -t 1 1
}

# Function to display disk usage
disk_usage() {
    echo "Disk Usage:"
    df -h | grep '^/dev/' | awk '{print $5 " used on " $1}'
    echo "Partitions using more than 80%:"
    df -h | awk '$5 > 80 {print}'
}

# Function to display system load
system_load() {
    echo "System Load:"
    uptime
    echo "CPU Usage Breakdown:"
    mpstat -P ALL 1 1
}

# Function to display memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h
    echo "Swap Memory Usage:"
    swapon --show
}

# Function to display process monitoring
process_monitoring() {
    echo "Process Monitoring:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -10
}

# Function to monitor essential services
service_monitoring() {
    echo "Service Monitoring:"
    for service in sshd nginx apache2 iptables; do
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is NOT running"
    done
}

# Function to refresh the dashboard every few seconds
dashboard() {
    while true; do
        clear
        echo "System Resource Monitoring Dashboard"
        echo "------------------------------------"
        top_10_apps
        network_monitoring
        disk_usage
        system_load
        memory_usage
        process_monitoring
        service_monitoring
        sleep 5
    done
}

# Check command-line arguments
case "$1" in
    --apps) top_10_apps ;;
    --network) network_monitoring ;;
    --disk) disk_usage ;;
    --load) system_load ;;
    --memory) memory_usage ;;
    --process) process_monitoring ;;
    --services) service_monitoring ;;
    *) dashboard ;;
esac
