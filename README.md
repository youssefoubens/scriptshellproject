Application Usage Monitor Script
Overview
This script is designed to monitor application usage on a Linux system. It tracks the time spent on each application and logs the activity to a specified file. Additionally, it provides functionalities for sorting downloaded files into folders and displaying server utilization information.

Features
Application Usage Monitoring: Tracks the start and end times of applications, calculating the duration of usage.
Background Monitoring: Can run in the background to continuously monitor application usage.
File Sorting: Organizes files in the Downloads directory based on their extensions into respective folders.
Server Utilization Display: Provides information on currently logged-on users, last logins, disk and memory usage, and system processes.
How to Use
Running the Script: Execute the script using ./script_name.sh.
Options:
-s: Displays server utilization information.
-o: Sorts files in the Downloads directory.
-b: Starts background monitoring of application usage.
-r: Stops background monitoring.
-h: Displays help information.
Background Monitoring: To start background monitoring, use the -b option. Use -r to stop it.
File Sorting: Use the -o option to organize files in the Downloads directory.
Server Utilization Display: Use the -s option to view server utilization information.
Example Usage
bash
Copier le code
# Display server utilization information
./script_name.sh -s

# Sort files in Downloads directory
./script_name.sh -o

# Start background monitoring
./script_name.sh -b

# Stop background monitoring
./script_name.sh -r
Dependencies
Bash (Bourne Again SHell)
ps, grep, date, notify-send, mkdir, mv, awk, df, free, top, w, last
Notes
Ensure the script has executable permissions (chmod +x script_name.sh).
