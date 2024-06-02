#!/bin/bash


source_dir="/path/to/source_directory"
destination="user@remote_server:/path/to/remote_directory"
report_file="/path/to/backup_report.txt"

# Backup function
perform_backup() {
    echo "Starting backup at $(date)" >> "$report_file"
    
    # Run rsync to perform the backup
    rsync -avz --delete "$source_dir" "$destination" >> "$report_file" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "Backup successful at $(date)" >> "$report_file"
    else
        echo "Backup failed at $(date)" >> "$report_file"
    fi
}

# Main
perform_backup
