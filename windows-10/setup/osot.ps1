$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$files = @("VMwareOSOptimizationTool.exe","VMwareOSOptimizationTool.exe.config","win10_1809_1909.xml")
$exe = $files[0]
$arg = "-o -t " + $files[2]

# Verify connectivity
if (Test-Connection $webserver -Quiet){
  # Get the OSOT files
  ForEach ($file in $files)
  {
    Invoke-WebRequest -Uri ($url + "/" + $file) -OutFile $env:TEMP\$file
  }
} else {
  throw "No connection to server. Aborting."
}

# Change to temp folder
Set-Location $env:TEMP

# Run OSOT
Try 
{
  Start-Process $exe -ArgumentList $arg -Passthru -Wait -ErrorAction stop
}
Catch
{
  Write-Error "Failed to run OSOT"
  Write-Error $_.Exception
  Exit -1 
}

# Delete files
ForEach ($file in $files)
{
  Remove-Item -Path $env:TEMP\$file -Confirm:$false
}
