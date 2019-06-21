
Function Get-RDJobList{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader,
        [Parameter(Mandatory = $False,
        ValueFromPipeline    = $True,
        ValueFromPipelinebyPropertyName=$True)]
        [String[]] 
        $ProjectName
    )
    Begin {
        If (!$Script:RDHeader){
            Write-Output "Connecting to Rundeck..."
            $Headers = Set-RDInfo
            $Script:RDHeader = $Headers
        }
        $URI = "$RundeckBaseURI/project/$ProjectName/jobs"
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
