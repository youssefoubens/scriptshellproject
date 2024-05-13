#!/bin/bash

# File to store activity
activity_file="user_activity.log"
temp_file="./running_processes.tmp"  # Temporary file to store running processes

# Associative array to store start times of applications
declare -A start_times

# Associative array to store the total time spent on each application
declare -A total_time_spent

# List of common system processes to ignore
system_processes=("kworker" "ata_sff" "cgroup_destroy")

# Function to log activity
log_activity() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="$1"
    echo "$timestamp - $message" >> "$activity_file"
}

# Function to monitor application usage
monitor_application_usage() {
    # Check if the temporary file exists, if not create it
    if [ ! -f "$temp_file" ]; then
        touch "$temp_file"
    fi

    while true; do
        # Get list of running processes
        running_processes=$(ps -eo comm=)
        # Compare with previous list to detect new processes
        for process in $running_processes; do
            # Check if the process is not a system process
            if ! is_system_process "$process"; then
                if ! grep -q "$process" "$temp_file"; then
                    start_times["$process"]=$(date +%s)
                    log_activity "Application opened: $process"
                fi
            fi
        done
        # Update temporary file
        echo "$running_processes" > "$temp_file"
        sleep 5  # Adjust interval as needed
    done
}

# Function to check if a process is a system process
is_system_process() {
    local process=$1
    for sys_proc in "${system_processes[@]}"; do
        if [[ $process == "$sys_proc" ]]; then
            return 0  # It's a system process
        fi
    done
    return 1  # Not a system process
}

# Function to monitor application closing
monitor_application_closing() {
    while true; do
        # Get list of running processes
        running_processes=$(ps -eo comm=)
        # Check for processes that were previously tracked
        for process in "${!start_times[@]}"; do
            # If the process is no longer running, calculate the duration
            if ! grep -q "$process" "$running_processes"; then
                end_time=$(date +%s)
                duration=$((end_time - start_times["$process"]))
                if [ -z "${total_time_spent[$process]}" ]; then
                    total_time_spent["$process"]=$duration
                else
                    total_time_spent["$process"]=$((total_time_spent["$process"] + duration))
                fi
                log_activity "Application closed: $process - Time spent: ${total_time_spent["$process"]} seconds"
                unset start_times["$process"]
            fi
        done
        sleep 5  # Adjust interval as needed
    done
}

# Function to display a notification message on the desktop
display_notification() {
    notify-send "Script Terminated" "The script has been terminated because $activity_file was accessed."
}

# Function to start the monitoring functions in the background
start_monitoring_in_background() {
    monitor_application_usage &
    monitor_application_closing &
    echo "Monitoring started in the background."
    exit 0
}

# Function to stop the monitoring functions running in the background.
stop_background_monitoring() {
    if pgrep -f "$(basename "$0")" >/dev/null; then
        echo "Stopping monitoring..."
        pkill -f "$(basename "$0")"
        echo "Monitoring stopped."
        exit 0
    else
        echo "Monitoring is not running."
        exit 1
    fi
}

# Function to order files in the Downloads directory
orderfiles() {
    
 
    directory="$HOME/Downloads"

    # Navigate to the directory
    cd "$directory" || exit

    # Create an array to store unique file extensions
    declare -A extensions

    # Loop through each file and extract its extension
    for file in *; do
        if [ -f "$file" ]; then
            extension="${file##*.}"
            extensions["$extension"]=1
        fi
    done

    # Create folders for each unique extension
    for extension in "${!extensions[@]}"; do
        mkdir -p "$extension"
    done

    # Move files to their respective folders
    for extension in "${!extensions[@]}"; do
        count=1
        for file in *."$extension"; do
            base_name="${file%.*}"
            new_name="$base_name-$count.$extension"
            while [ -e "$extension/$new_name" ]; do
                ((count++))
                new_name="$base_name-$count.$extension"
            done
            mv "$file" "$extension/$new_name"
            ((count++))
        done
    done

    echo "Files sorted into folders."




}


# Function to display server utilization information.
server_utilization() {
    RED="\e[1;31m"
    GREEN="\e[1;32m"
    EXIT="\e[0m"

    # Function to print a divider line.
    divider () {
        echo -e "${RED}===========================================${EXIT}"
    }

    # Function to display server utilization information.
    display_server_utilization() {
        clear

        # Displaying the title of the script.
        echo -e "                               ${GREEN}****${EXIT}"
        echo -e "                               ${GREEN}* SERVER UTILIZATION *${EXIT}"
        echo -e "                               ${GREEN}****${EXIT}"
        divider
        echo 

        # Displaying the current date.
        echo -e "Today's date is : $(date +"%Y-%m-%d %H:%M:%S")"
        echo
        divider
        echo 

        # Displaying currently logged-on users.
        echo "Currently logged-on users:"
        w
        echo
        divider
        echo 

        # Displaying last logins.
        echo "Last logins"
        last -a | head -n 3
        echo 
        divider
        echo 

        # Displaying disk and memory usage.
        echo "Disk and Memory usage"
        echo
        df -h | xargs | awk '{print "Free/Total disk:" $11 "/" $9 }'
        echo
        free -m | xargs | awk '{print "Free/Total memory: " $17 "/" $8"  MB"}'
        echo
        divider
        echo 

        # Displaying system utilization and most expensive processes.
        echo "Utilization and most expensive processes"
        echo
        top -b | head -n 3
        echo 
        top -b | head -n 10 | tail -n 4
        echo
        divider
        exit
    }

    # Parse command-line options
    while getopts ":h" opt; do
        case ${opt} in
            h )
                echo "Usage: $(basename "$0") [-h]"
                echo "Options:"
                echo "  -h : Display this help message."
                exit 0
                ;;
            \? )
                echo "Invalid option: $OPTARG" 1>&2
                echo "Usage: $(basename "$0") [-h]"
                echo "Options:"
                echo "  -h : Display this help message."
                exit 1
                ;;
        esac
    done

    # If no options are provided, display server utilization information
    if [ $OPTIND -eq
    1 ]; then
        display_server_utilization
    fi
}

# Function to display help information.
display_help() {
    echo "Usage: $(basename "$0") [options]"
    echo "Options:"
    echo "  -h : Display this help message."
    echo "  -s : Run server_utilization function."
    echo "  -r : Stop monitoring in the background."
    echo "  -o : Run orderfiles function."
    echo "  -b : Start monitoring in the background."
    exit 0
}

# Parse command-line options
while getopts ":hsuobr" opt; do
    case ${opt} in
        h )
            display_help
            ;;
        s )
            server_utilization
            ;;
        o )
            orderfiles
            ;;
        b )
            start_monitoring_in_background
            ;;
        r )
            stop_background_monitoring
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            display_help
            ;;
    esac
done

# If no options are provided, display help message
if [ $OPTIND -eq 1 ]; then
    display_help
f