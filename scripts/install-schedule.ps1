$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$python = Join-Path $root '.venv\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $python)) { $python = 'python' }
$log = Join-Path $root 'data\alfred.log'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $log) | Out-Null
$command = '"' + $python + '" -m alfred *>> "' + $log + '"'
$arguments = '-NoProfile -NonInteractive -WindowStyle Hidden -Command "Set-Location -LiteralPath ''' + $root + '''; $env:PYTHONPATH=''' + $root + '\src''; ' + $command + '"'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arguments
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 20) -MultipleInstances IgnoreNew
Register-ScheduledTask -TaskName 'AlfredGmailTriageMorning' -Action $action -Trigger (New-ScheduledTaskTrigger -Daily -At 7:00AM) -Settings $settings -Description 'Alfred Gmail triage at 7 AM' -Force | Out-Null
Register-ScheduledTask -TaskName 'AlfredGmailTriageEvening' -Action $action -Trigger (New-ScheduledTaskTrigger -Daily -At 7:00PM) -Settings $settings -Description 'Alfred Gmail triage at 7 PM' -Force | Out-Null
Write-Host 'Installed Alfred schedules for 07:00 and 19:00 local time.'

