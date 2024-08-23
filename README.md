
note: Before you start working, you can implement the script as per your requirement either in mulitple scripts (as show below) or in single script, i puted single one bcz its easier to run and look upto.

### Step-by-Step Implementation:

1. **Create the Enhanced Script:**
   - Open a terminal and create a new script file:
     ```bash
     nano enhanced_monitor.sh
     ```
   - Copy and paste the above script into `enhanced_monitor.sh`.

2. **Make the Script Executable:**
   - Run the following command to make the script executable:
     ```bash
     chmod +x enhanced_monitor.sh
     ```

3. **Install Required Utilities:**
   - Ensure the necessary utilities (`mpstat`, `ifstat`, `netstat`, etc.) are installed:
     ```bash
     sudo apt-get install sysstat ifstat net-tools
     ```

4. **Run the Script:**
   - To display the full dashboard, run:
     ```bash
     ./enhanced_monitor.sh
     ```
   - To view specific metrics, use the command-line switches:
     - Top 10 Apps: `./enhanced_monitor.sh --apps`
     - Network Monitoring: `./enhanced_monitor.sh --network`
     - Disk Usage: `./enhanced_monitor.sh --disk`
     - System Load: `./enhanced_monitor.sh --load`
     - Memory Usage: `./enhanced_monitor.sh --memory`
     - Process Monitoring: `./enhanced_monitor.sh --process`
     - Service Monitoring: `./enhanced_monitor.sh --services`

  
