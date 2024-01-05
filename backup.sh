#!/bin/bash

# Variables for GitHub repository, local project folder, and backup directory
github_repo="https://github.com/username/repository.git"
local_project_folder="/path/to/local/project"
backup_dir="/path/to/backup/directory"

# Function to perform backup
perform_backup() {
    # Create a timestamp for the backup
    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')

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
}

# Execute backup function
perform_backup




