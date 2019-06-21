Function Get-RDExecutionOutput(){
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader,
        [Parameter(Mandatory = $True)]
        [System.String] 
        $ExecutionID
    )
    Begin {
        If (!$Script:RDHeader){
            Write-Output "Connecting to Rundeck..."
            $Headers = Set-RDInfo
            $Script:RDHeader = $Headers
        }
        $URI = "$RundeckBaseURI/execution/$ExecutionID/output/state"
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