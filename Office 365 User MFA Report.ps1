Connect-MsolService

Write-Host "Finding accounts..." -ForegroundColor white -BackgroundColor Black
$Users = Get-MsolUser -All | Where-Object { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new()

Start-Sleep 1.5
Write-Host $users.count "Accounts found" -ForegroundColor white -BackgroundColor Black


ForEach ($user in $users) {

    $mfadefaultmethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True"}).methodtype
    $userupn = $user.UserPrincipalName
    $displayname = $user.displayname

    If (($user.StrongAuthenticationRequirements.state) -eq "Enforced") {
        $state = $User.StrongAuthenticationRequirements.State
    }
    Else {
        $state = 'Disabled'
    }
    If ($mfadefaultmethod) {
        Switch ($mfadefaultmethod) {
        "OneWaySMS" { $Method = "SMS" }
        "TwoWayVoiceMobile" { $Method = "Phone call" }
        "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
        "PhoneAppNotification" { $Method = "Authenticator app" }
        }
    }

    Else {
        $mfadefaultmethod = "Not set"
   }
     $ReportLine = [PSCustomObject] @{
        UserPrincipalName = $User.UserPrincipalName
        DisplayName       = $User.DisplayName
        MFAState          = $State
        MFADefaultMethod  = $MFADefaultMethod
    }
                 
    $Report.Add($ReportLine)

   }
$Report | Export-CSV -Encoding UTF8 -NoTypeInformation "c:\temp\m365mfareport.csv"
