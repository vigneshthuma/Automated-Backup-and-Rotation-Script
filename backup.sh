#!/bin/bash

# Variables for GitHub repository, local project folder, and backup directory
github_repo="https://github.com/username/repository.git"
local_project_folder="/path/to/local/project"
backup_dir="/path/to/backup/directory"

# Variables for backup directory and retention periods
backup_dir="/path/to/backup/directory"
num_daily_backups=7
num_weekly_backups=4
num_monthly_backups=3

# Function to perform rotational backup strategy
perform_rotational_backup() {
    # Find and sort backup directories
    backup_directories=($(find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | sort -r))

    # Calculate retention periods
    num_backups=${#backup_directories[@]}
    num_daily=$((num_daily_backups * 1))
    num_weekly=$((num_daily + (num_weekly_backups * 7)))
    num_monthly=$((num_weekly + (num_monthly_backups * 30)))

    # Loop through backup directories and delete older backups
    for ((i = 0; i < num_backups; i++)); do
        if [[ $i -ge $num_daily && $i -lt $num_weekly ]]; then
            echo "Keeping daily backup: ${backup_directories[$i]}"
        elif [[ $i -ge $num_weekly && $i -lt $num_monthly ]]; then
            echo "Keeping weekly backup: ${backup_directories[$i]}"
        elif [[ $i -ge $num_monthly ]]; then
            echo "Keeping monthly backup: ${backup_directories[$i]}"
        else
            echo "Deleting old backup: ${backup_directories[$i]}"
            rm -rf "${backup_directories[$i]}"
        fi
    done

    # Log backup information to a file
    log_file="backup_log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Rotational backup performed" >> "$log_file"
}

# Execute rotational backup function
perform_rotational_backup


perform_backup() {

    # Clone the GitHub repository to the local project folder if not already present
    if [ ! -d "$local_project_folder" ]; then
        git clone "$github_repo" "$local_project_folder"
    else
        # Pull latest changes if the repository exists
        cd "$local_project_folder" || exit
        git pull origin main  # Adjust branch name as needed
    fi

    # Create a backup directory with timestamp
    backup_folder="$backup_dir/backup_$timestamp"
    mkdir -p "$backup_folder"

    # Copy project files to the backup directory
    cp -r "$local_project_folder" "$backup_folder/project_backup_$timestamp"

    # Generate a ZIP file from the project folder
    zip_file="$backup_folder/project_backup_$timestamp.zip"
    zip -r "$zip_file" "$project_folder"

    # Log the backup status
    echo "Backup completed at $timestamp: Project backed up to $backup_folder" >> backup_log.txt

     # Make cURL request on successful backup
    curl -X POST -H "Content-Type: application/json" -d '{"project": "YourProjectName", "date": "'"$(date '+%Y-%m-%d %H:%M:%S')"'", "test": "BackupSuccessful"}' https://webhook.site/your-unique-url
}

# Execute backup function
perform_backup




