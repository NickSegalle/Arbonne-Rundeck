function Get-RDJob
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader,
        [Parameter(Mandatory = $False,
        ValueFromPipeline    = $True,
        ValueFromPipelinebyPropertyName=$True)]
        [String[]] 
        $JobID,
        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('XML', 'YAML')]
        [System.String]
        $Format = 'XML'
    )
    Begin {
        If (!$Script:RDHeader){
            Write-Output "Connecting to Rundeck..."
            $Headers = Set-RDInfo
            $Script:RDHeader = $Headers
        }
        If($Format -eq "XML")
        {
            $URI = "$RundeckBaseURI/job/$JobID`?format=xml"
        }
        Else {
            $URI = "$RundeckBaseURI/job/$JobID`?format=yaml"
        }
    }
    Process {
        Try
        {
            Invoke-RundeckMethod -Uri $URI -Headers $Headers 
        }
        Catch
        {
            Write-Output "Ran into an issue getting Rundeck Jobs: $($PSItem.ToString())"
        }
    }
}
