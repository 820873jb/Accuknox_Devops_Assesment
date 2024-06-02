#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="/var/log/system_health.log"

log message()
{
    echo "$(date) :$1" | tee -a $LOG_FILE
}

check_cpu() {

    CPU_USAGE=$(top -bn1 | grep 
    "Cpu(s) | sed "s/.*,*\([0-9.]*\)%* id.*/\1/" | awk '{print 100 -$1})
    if(($(rcho "$CPU_USAGE > $CPU_THRESHOLDF" | bc -l))); then
    log_message "High CPU usage detected: $CPU_USAGE%"
    else
    log_message "CPU usage is normal: $CPU_USAGE%"
    fi
}
check_memory() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "High Memory Usage Detected: $memory_usage%"
    fi
}
check_disk() {
    local disk_usage=$(df -h | awk '$NF=="/"{printf "%s", $5}' | sed 's/%//')
    if (( disk_usage >= DISK_THRESHOLD )); then
        echo "High Disk Usage Detected: $disk_usage%"
    fi
    }
    check_processes() {
    local process_count=$(ps aux | wc -l)
    if (( process_count > 200 )); then
        echo "High Number of Running Processes Detected: $process_count"
    fi
}
# Main function
main() {
    echo "Checking System Health..."
    check_cpu
    check_memory
    check_disk
    check_processes
}
main