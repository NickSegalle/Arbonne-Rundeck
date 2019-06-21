Function New-RDAuthHeader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $APIToken
    )
    $Header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Header.Add("Accept", "application/json")
    $Header.Add("Content-Type", "application/json")
    $Header.Add("X-Rundeck-Auth-Token", "$APIToken")
    $Header
}
