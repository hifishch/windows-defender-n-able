#Powershell Windows Defender Reporting & Enforcement for N-able RMM
#Author: Andreas Walker andreas.walker@walkerit.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.0 / 04.12.2022


#Get Windows Defender Status
$DefenderStatus = Get-MpComputerStatus
$DefenderPreferences = Get-MpPreference
$AgeLimit = (date).AddHours(-12)
$ErrorCount = 0

#Check Windows Defender Running Mode quit with error if not normal
if ($DefenderStatus.AMRunningMode -ne "normal")
    {
    Write-Host ERROR - Windows Defender is in Runnungmode $DefenderStatus.AMRunningMode
    Exit 1001
    }

#Check Antivirus
if ($DefenderStatus.AntivirusEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender Antivirus is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check Antimalware Service
if ($DefenderStatus.AMServiceEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender Anti Malware Service is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check AntiSpyware Service
if ($DefenderStatus.AntispywareEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender Anti Spyware Service is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check BehaviorMonitor Service
if ($DefenderStatus.BehaviorMonitorEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender Behavior Monitor Service is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check IoavProtection Service
if ($DefenderStatus.IoavProtectionEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender IOAV Protection Service is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check NIS Service
if ($DefenderStatus.NISEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender NIS Service is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check OnAccessProtection
if ($DefenderStatus.OnAccessProtectionEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender On Access Protection is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Check RealTimeProtection
if ($DefenderStatus.RealTimeProtectionEnabled -ne $true)
    {
    Write-Host INFO - Windows Defender RealTime Protection is disabled.
    $ErrorCount = $ErrorCount + 1
    }

#Checking age of Definitions and trigger update if required
if ($DefenderStatus.AntispywareSignatureLastUpdated -lt $AgeLimit -and $DefenderStatus.AntivirusSignatureLastUpdated -lt $AgeLimit -and $DefenderStatus.NISSignatureLastUpdated -lt $AgeLimit)
    {
    Write-Host INFO - Some of the Definitions had been updated before $DateLimit
    Write-Host Definition-Versions:
    Write-Host Antispyware Signatures: $DefenderStatus.AntispywareSignatureVersion - $DefenderStatus.AntispywareSignatureLastUpdated
    Write-Host Antivirus Signaures: $DefenderStatus.AntivirusSignatureVersion - $DefenderStatus.AntivirusSignatureLastUpdated
    Write-Host NIS Signatures: $DefenderStatus.NISSignatureVersion - $DefenderStatus.NISSignatureLastUpdated
    Write-Host INFO - Updating Definitions from Microsoft Server
    Update-MpSignature -UpdateSource MicrosoftUpdateServer -ErrorAction Continue
    }

#Checking exclusion paths
if ($DefenderPreferences.ExclusionPath)
    {
    Write-Host INFO - Following Paths are excluded from Windows Defender Scans: $DefenderStatus.ExclusionPath
    }

#Checking excluded Extensions
if ($DefenderPreferences.ExclusionExtension)
    {
    Write-Host INFO - Following File Extensions are excluded from Windows Defender Scans: $DefenderStatus.ExclusionExtension
    }

#Checking excluded Extensions
if ($DefenderPreferences.ExclusionProcess)
    {
    Write-Host INFO - Following Processes are excluded from Windows Defender Scans: $DefenderStatus.ExclusionProcess
    }

#Checking excluded IPs
if ($DefenderPreferences.ExclusionIpAddress)
    {
    Write-Host INFO - Following IPs are excluded from Windows Defender Scans: $DefenderStatus.ExclusionIpAddress
    }

#Review error counter

if ($ErrorCount -eq 0)
    {
    Write-Host OK - All Windows Defender-Services seem to be OK
    exit 0
    }
    else
        {
        Write-Host ERROR - $ErrorCount Windows Defender services are disabled or not running. Restoring Windows Defender Default Baselines
        Set-MpPreference -DisableArchiveScanning $false
        Set-MpPreference -DisableAutoExclusions $false
        Set-MpPreference -DisableBehaviorMonitoring $false
        Set-MpPreference -DisableBlockAtFirstSeen $false
        Set-MpPreference -DisableDatagramProcessing $false
        Set-MpPreference -DisableDnsOverTcpParsing $false
        Set-MpPreference -DisableDnsParsing $false
        #Set-MpPreference -DisableFtpParsing $false
        Set-MpPreference -DisableGradualRelease $false
        Set-MpPreference -DisableHttpParsing $false
        Set-MpPreference -DisableInboundConnectionFiltering $false
        Set-MpPreference -DisableIOAVProtection $false
        Set-MpPreference -DisableNetworkProtectionPerfTelemetry $false
        Set-MpPreference -DisablePrivacyMode $false
        Set-MpPreference -DisableRdpParsing $false
        Set-MpPreference -DisableRealtimeMonitoring $false
        Set-MpPreference -DisableScanningNetworkFiles $false
        Set-MpPreference -DisableScriptScanning $false
        Set-MpPreference -DisableSmtpParsing $false
        Set-MpPreference -DisableSshParsing $false
        #Set-MpPreference -DisableTDTFeature $false
        Set-MpPreference -DisableHttpParsing $false
        Set-MpPreference -DisableTlsParsing $false
        Set-MpPreference -DisableCatchupFullScan $true
        Set-MpPreference -DisableCatchupQuickScan $true
        Set-MpPreference -DisableCpuThrottleOnIdleScans $true
        Set-MpPreference -DisableEmailScanning $true
        Set-MpPreference -DisableRemovableDriveScanning $true
        Set-MpPreference -DisableRestorePoint $true
        Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan $true
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "Real-Time Protection" -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 0 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 0 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 0 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -PropertyType DWORD -Force | Out-Null
        Start-Service WinDefend
        Start-Service WdNisSvc
        Start-Service SecurityHealthService
        Exit 1001
        }

#Catch unexpected end
Write-Host ERROR - The Script came to an unexpected end.
exit 1001