#!/bin/bash
# Script: security_audit.sh
# Description: Automates security audits and server hardening.

# Log file
LOGFILE="/var/log/security_audit.log"
exec > >(tee -i $LOGFILE)
exec 2>&1

#User and Group Audits
echo "User and Group Audits" >> $LOGFILE
echo "Listing all users and groups:" >> $LOGFILE
getent passwd >> $LOGFILE

echo "Checking for users with UID 0:" >> $LOGFILE
awk -F: '($3 == 0) {print}' /etc/passwd >> $LOGFILE

echo "Checking for users with weak or no passwords:" >> $LOGFILE
awk -F: '($2 == "" || $2 == "x") {print $1 " has no or weak password"}' /etc/shadow >> $LOGFILE

#File and Directory Permissions
echo "File and Directory Permissions" >> $LOGFILE
echo "Scanning for world-writable files:" >> $LOGFILE
find / -type f -perm -o=w >> $LOGFILE

echo "Checking .ssh directory permissions:" >> $LOGFILE
find / -type d -name ".ssh" -exec stat -c "%a %n" {} \; | awk '$1 != "700" {print $2 " has insecure permissions"}' >> $LOGFILE

echo "Checking for SUID/SGID files:" >> $LOGFILE
find / -perm /6000 -type f >> $LOGFILE

#Service Audits
echo "Service Audits" >> $LOGFILE
echo "Listing all running services:" >> $LOGFILE
service --status-all >> $LOGFILE

echo "Checking for SSHD and iptables services:" >> $LOGFILE
systemctl is-active sshd >> $LOGFILE
systemctl is-active iptables >> $LOGFILE

echo "Checking for non-standard ports:" >> $LOGFILE
netstat -tulnp | grep -v "127.0.0.1" >> $LOGFILE

#Firewall and Network Security
echo "Firewall and Network Security" >> $LOGFILE
echo "Verifying firewall status:" >> $LOGFILE
ufw status >> $LOGFILE

echo "Listing open ports and their services:" >> $LOGFILE
netstat -tulnp | grep LISTEN >> $LOGFILE

echo "Checking for IP forwarding:" >> $LOGFILE
sysctl net.ipv4.ip_forward >> $LOGFILE

#IP and Network Configuration Checks
echo "IP and Network Configuration Checks" >> $LOGFILE
echo "Identifying IP addresses:" >> $LOGFILE
hostname -I >> $LOGFILE

echo "Checking if SSH is exposed on public IPs:" >> $LOGFILE
ss -tulwn | grep ":22" >> $LOGFILE

#Security Updates and Patching
echo "Security Updates and Patching" >> $LOGFILE
echo "Checking for available updates:" >> $LOGFILE
apt-get update && apt-get upgrade -s >> $LOGFILE

echo "Applying security updates:" >> $LOGFILE
apt-get upgrade -y >> $LOGFILE

#Server Hardening Steps
echo "Server Hardening Steps" >> $LOGFILE

echo "Configuring SSH for key-based authentication and disabling root login:" >> $LOGFILE
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "Disabling IPv6:" >> $LOGFILE
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >> $LOGFILE
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >> $LOGFILE

echo "Securing the bootloader:" >> $LOGFILE
echo "password_pbkdf2 root $(grub-mkpasswd-pbkdf2 | grep pbkdf2)" >> /etc/grub.d/40_custom
update-grub

echo "Configuring automatic updates:" >> $LOGFILE
apt-get install unattended-upgrades -y >> $LOGFILE
dpkg-reconfigure -plow unattended-upgrades >> $LOGFILE

#Custom Security Checks
echo "Running custom security checks" >> $LOGFILE
if [ -f custom_checks.sh ]; then
    bash custom_checks.sh >> $LOGFILE
fi

#Reporting and Alerting
echo "Generating Summary Report..." >> $LOGFILE
cp $LOGFILE /var/log/security_audit_report.txt

# Optional: Send email alerts
if grep -q "Critical" /var/log/security_audit_report.txt; then
    mail -s "Critical Security Issues Found" admin@example.com < /var/log/security_audit_report.txt
fi

