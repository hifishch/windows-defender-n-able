# Windows Defender Automation for N-able RMM
Some customers wish to manage Antivirus exeptions by themself or simply cheap out on the Antivirus. In this case I usually use Windows Defender.
The scripts in this repo allow to manage Windows Defender via N-Able RMM to a certain level.

## Enforce-WindowsDefender
Allows to enforce Windows Defaults observed in Windows 10/11 21H2. If the user changes something an error is generated and the baselane is restored via powershell commands and registry settings.
This script also reads exceptions and writes them as INFO-messages into the RMM. Even Though this script doesn't touch any exceptions made by the user, it helps you to kind of monitor them.
Nice side effect of this script: It also starts an definiton update if the last update has been more than 12 hours ago.
#### Parameters
* None
#### Recommended Usage:
* Daily or 24/7 Check
* Max-Execution Time: 300 Seconds

## Get-WindowsDefenderDetections
This script generates an Error in RMM when Windows Defender detected something in the last 24 hours. Use this to central monitor detection in N-Able RMM.
#### Parameters
* None
#### Recommended Usage:
* 24/7 Check
* Max-Execution Time: 120 Seconds

## Update-WindowsDefender
Updates Windows Defender definitions and checks if they are younger than 24 hours after the update.
#### Parameters
* None
#### Recommended Usage:
* Task if Antivirus Update-Check in RMM fails
* Max-Execution Time: 300 Seconds
