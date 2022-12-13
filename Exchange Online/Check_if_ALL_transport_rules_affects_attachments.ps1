<#
.DESCRIPTION
Checks if all transport rules affect mail attachments and exports the properties of each rule that pertain to attachments to a CSV file.
.NOTES
  Version:        1.0.0
  Author:         Daniel Bradley
  Twitter:        https://twitter.com/DanielatOCN
  Website:        https://ourcloudnetwork.com/
  LinkedIn        https://www.linkedin.com/in/danielbradley2/
  Creation Date:  13/12/2022
  Purpose/Change: First draft
#>

#Connect to Exchange Online
Connect-ExchangeOnline

#Create Report object
$Report = [System.Collections.Generic.List[Object]]::new()

#Store all transport rules
$alltransportrules = get-transportrule

#Loop through all transport rules
ForEach ($Rule in $alltransportrules){

#Store rule parameters which affect attachments
$attachmentrules = get-transportrule $rule.name | Select *attachment*

#Convert array objects to string
$string1 = $attachmentrules.AttachmentExtensionMatchesWords | out-string
$attachmentrules.AttachmentExtensionMatchesWords = $string1
$string2 = $attachmentrules.AttachmentNameMatchesPatterns | out-string
$attachmentrules.AttachmentNameMatchesPatterns = $string2
$string3 = $attachmentrules.AttachmentPropertyContainsWords | out-string
$attachmentrules.AttachmentPropertyContainsWords = $string3
$string4 = $attachmentrules.AttachmentContainsWords | out-string
$attachmentrules.AttachmentContainsWords = $string4
$string5 = $attachmentrules.AttachmentMatchesPatterns | out-string
$attachmentrules.AttachmentMatchesPatterns = $string5
$string6 = $attachmentrules.ExceptIfAttachmentNameMatchesPatterns | out-string
$attachmentrules.ExceptIfAttachmentNameMatchesPatterns = $string6
$string7 = $attachmentrules.ExceptIfAttachmentExtensionMatchesWords | out-string
$attachmentrules.ExceptIfAttachmentExtensionMatchesWords = $string7
$string8 = $attachmentrules.ExceptIfAttachmentPropertyContainsWords | out-string
$attachmentrules.ExceptIfAttachmentPropertyContainsWords = $string8
$string9 = $attachmentrules.ExceptIfAttachmentSizeOver | out-string
$attachmentrules.ExceptIfAttachmentSizeOver = $string9
$string10 = $attachmentrules.ExceptIfAttachmentContainsWords | out-string
$attachmentrules.ExceptIfAttachmentContainsWords = $string10
$string11 = $attachmentrules.ExceptIfAttachmentMatchesPatterns | out-string
$attachmentrules.ExceptIfAttachmentMatchesPatterns = $string11
$string = "$attachmentrules"

#Define regex parameters
$reg = [RegEx]"(\w+)=(\w*)"

#Create report to review
$table=@()
$table = $reg.Matches($string) | ForEach-Object {
    $rhs = if($_.Groups[2].Value){
        $_.Groups[2].Value
    }else{
        "N/A"
    }
    $obj = [PSCustomObject][ordered]@{
        "RULE NAME" = $Rule.name
        "TYPE" = $_.Groups[1].Value
        "VALUE" = $rhs
    }
    $Report.Add($obj)
} | Format-Table
}

#Display report in session
$report

#Export report to csv 
$report | export-csv C:\temp\AllMailRuleAttachmentInfo.csv -NoTypeInformation

