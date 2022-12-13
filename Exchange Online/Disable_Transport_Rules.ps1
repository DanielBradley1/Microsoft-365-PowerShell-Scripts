<#
.DESCRIPTION
Disable a single transport rule in Exchange Online
.NOTES
  Version:        1.0.0
  Author:         Daniel Bradley
  Twitter:        https://twitter.com/DanielatOCN
  Website:        https://ourcloudnetwork.com/
  LinkedIn        https://www.linkedin.com/in/danielbradley2/
  Creation Date:  13/12/2022
  Purpose/Change: First draft
#>

#Import module
Import-Module ExchangeOnlineManagement

#Connect to Exchange Online
Connect-ExchangeOnline

#View a list of enabled transport rules
Get-TransportRule | Where-Object {$_.State -eq "Enabled"}

#Define and store your transport rule
$Rule = Get-TransportRule -Identity "###Block .exe attachments###"

#Check if enabled and disable the rule
If ($rule.state -eq "Enabled") {
   Disable-TransportRule -Identity $Rule.Name -confirm:$false
    Write-host $rule.name ": has been disabled" -ForegroundColor black -BackgroundColor green
} Else {
    Write-host $rule.name ": is already disabled" -ForegroundColor black -BackgroundColor yellow
}
