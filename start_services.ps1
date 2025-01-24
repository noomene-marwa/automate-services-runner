# PowerShell Script to Start Microservices in Windows
# Define the services and their ports
$services = @{
    "user-service" = 8000
    "school-service" = 8001
    "course-service" = 8002
    "assignment-service" = 8003
    "assessment-service-" = 8004
    "report-service" = 8005
    "roster-service" = 8006
    "master-service" = 8007
    "digital-library" = 8008
    "cms-service" = 8009
    "notification-service" = 8010
}

# Directories
$developerFolder = "<YOUR_PROJECT_ROOT_PATH>"
$backendBaseDir = "$developerFolder\<FOLDER_NAME>"
$sharedVenvDir = "$backendBaseDir\venv"

# PID and status files
$pidFile = "$backendBaseDir\service_pids.txt"
$statusFile = "$backendBaseDir\service_statuses.txt"

# Function to update and start services
function Update-And-Start-Service {
    param (
        [string]$service,
        [int]$port
    )

    $serviceDir = "$backendBaseDir\$service"

    if (Test-Path $serviceDir) {
        Write-Host "Updating $service..."

        # Set the service directory
        Set-Location $serviceDir

        # Git pull
        git checkout main
        git pull origin main
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to update $service"
            Add-Content $statusFile "${service}: Git pull failed"
            return
        }
 
        Write-Host "Starting $service on port $port..."

        # Activate virtual environment
        & "$sharedVenvDir\Scripts\activate"

        # Run Django server
        Start-Process -NoNewWindow -FilePath "python" -ArgumentList "manage.py runserver 127.0.0.1:$port" -RedirectStandardOutput "$serviceDir\service.log" -PassThru | ForEach-Object {
            $processId = $_.Id  
            Add-Content $pidFile "$service $processId"
            Add-Content $statusFile "${service}: Started successfully"
        }
    } else {
        Write-Host "Directory $serviceDir does not exist"
        Add-Content $statusFile "${service}: Directory not found"
    }
}

# Function to stop services
function Stop-Services {
    if (Test-Path $pidFile) {
        Get-Content $pidFile | ForEach-Object {
            $service, $processId = $_ -split " "
            if (Get-Process -Id $processId -ErrorAction SilentlyContinue) {
                Write-Host "Stopping $service with PID $processId..."
                Stop-Process -Id $processId -Force
                Add-Content $statusFile "${service}: Stopped successfully"
            }
        }
        Remove-Item $pidFile
    } else {
        Write-Host "No service PIDs found. Services may not be running."
    }
}

# Start or Stop services based on arguments
if ($args[0] -eq "stop") {
    Write-Host "Stopping all services..."
    Stop-Services
    exit 0
} elseif ($args[0] -eq "start" -or !$args) {
    Write-Host "Starting all services..."
} else {
    Write-Host "Usage: .\start_services.ps1 [start|stop]"
    exit 1
}

# Activate virtual environment
Write-Host "Activating shared virtual environment..."
& "$sharedVenvDir\Scripts\activate"

# Remove old PID and status files
if (Test-Path $pidFile) { Remove-Item $pidFile }
if (Test-Path $statusFile) { Remove-Item $statusFile }

# Start services
foreach ($service in $services.Keys) {
    Update-And-Start-Service $service $services[$service]
}

Write-Host "All backend services attempted to start."

# Display service status summary
Write-Host "Summary of service statuses:"
Get-Content $statusFile
