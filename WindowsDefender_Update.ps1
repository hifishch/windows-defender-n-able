#Powershell Windows Defender-Update for N-able RMM
#Author: Andreas Walker andreas.walker@walkerit.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.1 / 12.08.2021

#Trigger Windows-Defender update from internet.
Update-MpSignature -UpdateSource MicrosoftUpdateServer

#Get new Windows-Defender status.
$NewStatus = Get-MpComputerStatus

#Checking state and generating exit-messages

if ($NewStatus.AntispywareSignatureAge -le 1 -and $NewStatus.AntivirusSignatureAge -le 1 -and $NewStatus.NISSignatureAge -le 1)
    {
    Write-Host "OK - Update Sucessful"
    Write-Host "Antivirus Signature:"$NewStatus.AntivirusSignatureVersion"("$NewStatus.AntivirusSignatureLastUpdated")"
    Write-Host "Antispyware Signature:"$NewStatus.AntispywareSignatureVersion"("$NewStatus.AntivirusSignatureLastUpdated")"
    Write-Host "NISS Signature:"$NewStatus.NISSignatureVersion"("$NewStatus.NISSignatureLastUpdated")"
    Exit 0
    }
    else
        {
        Write-Host "ERROR - One update is older than one day:"
        Write-Host "Antivirus Signature:"$NewStatus.AntivirusSignatureVersion"("$NewStatus.AntivirusSignatureLastUpdated")"
        Write-Host "Antispyware Signature:"$NewStatus.AntispywareSignatureVersion"("$NewStatus.AntivirusSignatureLastUpdated")"
        Write-Host "NISS Signature:"$NewStatus.NISSignatureVersion"("$NewStatus.NISSignatureLastUpdated")"
        Exit 1001
        }

#Catch unexpected end
Write-Host "The Script came to an unexpected end."
Exit 1001
