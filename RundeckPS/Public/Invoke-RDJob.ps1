Function Invoke-RDJob
{
    <#
    .SYNOPSIS
        Invoke Rundeck Job
    .EXAMPLE
        $JobBody = @{
            loglevel = "INFO" 
            asUser   = "nsegalle"
            filter   = "USZIN-RDNODE-01-SVC-RD_ServiceDesk"
            options  =  @{
                DomainName  = 'arbonnewest.com'
            }
        }
    .EXAMPLE
        !rdjl --p servicedesk
    .EXAMPLE
        !RDJobList --project opsutilities
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader,
        [Parameter(Mandatory = $False)]
        [String[]] 
        $JobID,
        [Parameter(Mandatory = $False)]
        [String]
        $Body
    )
    Begin {
        If (!$Headers){
            Write-Output "Connecting to Rundeck..."
            $Headers = Set-RDInfo
        }
        $URI = "$RundeckBaseURI/job/$JobID/run"
    }
    Process {
        Try
        {
            #$JobBodyJson = $Body | ConvertTo-Json
            Invoke-RundeckMethod -Uri $URI -Headers $Headers -Body $Body
        }
        Catch
        {
            Write-Output "Ran into an issue getting Rundeck Jobs: $($PSItem.ToString())"
        }
    }
}
