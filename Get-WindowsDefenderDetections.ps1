#Powershell Windows Defender Detections for N-able RMM
#Author: Andreas Walker andreas.walker@walkerit.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.0 / 04.12.2022


#Parameters
$AgeLimit = (Get-Date).AddHours(-24)
$WindowsDefenderDetections = Get-MpThreatDetection | Where {$_.LastThreatStatusChangeTime -gt $AgeLimit}

#Check Detections
if (!$WindowsDefenderDetections)
    {
    Write-Host OK - No Windows Defender detections found in the last 24 hours.
    Exit 0
    }
    else
        {
        Write-Host ERROR - Windows Defender detections found in the last 24 hours.
        Write-Host ********************
        #Print Detections
        foreach ($Detection in $WindowsDefenderDetections)
            {
            $Detail = Get-MpThreat -ThreatID $Detection.ThreatID
            if ($Detection.ActionSuccess) {$DetectionStatus = "Cleaned"} else {$DetectionStatus = "Not Cleaned!"}
            Write-Host * Threat: $Detail.ThreatName - ID: $Detection.ThreatID
            Write-Host * Detection: $Detection.InitialDetectionTime $Detection.DetectionID
            Write-Host * User: $WindowsDefenderDetections.DomainUser
            Write-Host * Process: $WindowsDefenderDetections.ProcessName
            Write-Host * Additional Ressources: $Detection.Resources
            Write-Host * Status: $DetectionStatus
            Write-Host ********************
            }
        Exit 1001
        }

#Catch unexpected end
Write-Host ERROR - The Script came to an unexpected end.
exit 1001