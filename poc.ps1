# Calculate Unix Epoch timestamp for the current date
$currentDateUnix = Get-Date -UFormat "%s"

# Calculate the date difference in seconds for the next 100 years
$dateDiff = ((Get-Date).AddYears(100).ToUniversalTime() - (Get-Date "1970-01-01").ToUniversalTime()).TotalSeconds

# Specify the path to your Git repository
$repositoryPath = "" # Change this to your desired path

# Check if the Git repository exists, and if not, initialize one
if (-not (Test-Path $repositoryPath -PathType Container)) {
    Write-Output "Initializing Git repository at $repositoryPath"
    git init $repositoryPath | Out-Null
    cd $repositoryPath
} else {
    Write-Output "Git repository already exists at $repositoryPath"
    cd $repositoryPath
}

# Loop through each day from Unix Epoch to the next 100 years and create a Git commit
for ($i = 0; $i -le $dateDiff; $i += 86400) {
    $commitDate = Get-Date -Date (Get-Date "1970-01-01").AddSeconds($i) -UFormat "%Y-%m-%d %H:%M:%S"
    Write-Output "Creating commit for $commitDate"

    # Your commit message and any other desired changes
    Set-Content -Path "temp_file.txt" -Value "Automatic commit for $commitDate"

    # Git commands
    git add .
    $env:GIT_COMMITTER_DATE = $commitDate
    git commit -m "Automatic commit for $commitDate" --date $commitDate
}

# Clear the environment variable after the loop
Remove-Item Env:\GIT_COMMITTER_DATE
