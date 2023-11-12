#!/bin/bash

# Calculate Unix Epoch timestamp for the current date
currentDateUnix=$(date +%s)

# Calculate the date difference in seconds for the next 100 years
dateDiff=$(( ( $(date -d "$(date -u -d '1970-01-01 00:00:00' +'%Y-%m-%d %H:%M:%S')" +%s) + 100*365*24*3600 ) - currentDateUnix ))

# Specify the path to your Git repository
repositoryPath="" # Change this to your desired path

# Check if the Git repository exists, and if not, initialize one
if [ ! -d "$repositoryPath/.git" ]; then
    echo "Initializing Git repository at $repositoryPath"
    git init "$repositoryPath"
fi

# Change to the Git repository directory
cd "$repositoryPath" || exit

# Loop through each day from Unix Epoch to the next 100 years and create a Git commit
for ((i = 0; i <= dateDiff; i += 86400)); do
    commitDate=$(date -u -d "@$((currentDateUnix + i))" "+%Y-%m-%d %H:%M:%S")
    echo "Creating commit for $commitDate"

    # Your commit message and any other desired changes
    echo "Automatic commit for $commitDate" > temp_file.txt

    # Git commands
    git add .
    GIT_COMMITTER_DATE="$commitDate" git commit -m "Automatic commit for $commitDate" --date "$commitDate"
done
