Function Set-RDInfo {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory=$False)]
        [string]
        $APIToken  = "VoMpREDAt5TdYSBZR4C3W2bzTAB2pRug"
    )
    $APIVersion = "30"
    $Script:RundeckServer = "rundeck.arbonnewest.com"
    $Script:RundeckBaseURI = "https://$RundeckServer/api/$APIVersion"
    $Script:RDHeader = New-RDAuthHeader -APIToken $APIToken
    $Script:RDHeader
}
