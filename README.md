# assignment1.1
Step-by-Step Implementation:
Create the Enhanced Script:

Open a terminal and create a new script file:
bash
Copy code
nano enhanced_monitor.sh
Copy and paste the above script into enhanced_monitor.sh.
Make the Script Executable:

Run the following command to make the script executable:
bash
Copy code
chmod +x enhanced_monitor.sh
Install Required Utilities:

Ensure the necessary utilities (mpstat, ifstat, netstat, etc.) are installed:
bash
Copy code
sudo apt-get install sysstat ifstat net-tools
Run the Script:

To display the full dashboard, run:
bash
Copy code
./enhanced_monitor.sh
To view specific metrics, use the command-line switches:
Top 10 Apps: ./enhanced_monitor.sh --apps
Network Monitoring: ./enhanced_monitor.sh --network
Disk Usage: ./enhanced_monitor.sh --disk
System Load: ./enhanced_monitor.sh --load
Memory Usage: ./enhanced_monitor.sh --memory
Process Monitoring: ./enhanced_monitor.sh --process
Service Monitoring: ./enhanced_monitor.sh --services
