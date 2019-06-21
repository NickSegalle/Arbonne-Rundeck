Function Get-RDProjectList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader
    )
    If (!$Headers)
    {
        Write-Output "Connecting to Rundeck..."
        $Headers = Set-RDInfo
        $Script:RDHeader = $Headers
    }
    $URI = "$RundeckBaseURI/projects"
    $ProjectResponse = Invoke-RundeckMethod -Headers $Headers -URI $URI
    $ProjectObject = @(ForEach ($Project in $ProjectResponse) {
        New-Object -Type PSObject -Property @{
            ProjectURL  = $Project.url
            ProjectName = $Project.Name
            ProjectDesc = $Project.description
            ProjectLabl = $Project.label
        }
    })
    $ProjectObject
}