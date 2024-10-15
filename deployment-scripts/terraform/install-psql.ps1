# Install-PostgreSQLClient.ps1

# Check if psql is already installed
if (Get-Command psql -ErrorAction SilentlyContinue) {
    Write-Host "psql is already installed. Skipping installation."
    exit 0
}

# Define PostgreSQL version and download URL
$pgVersion = "16.1"
$downloadUrl = "https://get.enterprisedb.com/postgresql/postgresql-$pgVersion-1-windows-x64.exe"

# Define installation directory
$installDir = "C:\Program Files\PostgreSQL\$pgVersion"

# Download PostgreSQL installer
$installerPath = "$env:TEMP\postgresql-$pgVersion-setup.exe"
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

# Install PostgreSQL silently
$arguments = "--unattendedmodeui minimal --mode unattended --superpassword postgres --servicename PostgreSQL --servicepassword postgres --enable-components pgAdmin,commandlinetools --disable-components server --prefix `"$installDir`""
Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait

# Add PostgreSQL bin directory to PATH
$pgBinPath = "$installDir\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentPath -notlike "*$pgBinPath*") {
    $newPath = "$currentPath;$pgBinPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    $env:Path = $newPath
}

# Verify installation
if (Get-Command psql -ErrorAction SilentlyContinue) {
    Write-Host "psql has been successfully installed and added to PATH."
}
else {
    Write-Host "Installation failed. Please check the logs and try again."
}

# Clean up
Remove-Item $installerPath -Force