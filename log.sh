#!/bin/bash

LOG_FILE="/var/log/security_audit.log"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Logging function with sudo
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOG_FILE
}

log "Starting security audit..."

# Example of a command with proper permissions
log "Listing all users:"
cut -d: -f1 /etc/passwd | sudo tee -a $LOG_FILE

log "Audit completed."
