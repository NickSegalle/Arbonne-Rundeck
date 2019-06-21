Function Get-RDNodeList(){
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
        $URI = "$RundeckBaseURI/project/$ProjectName/resources"
    }
    Process {
        Try
        {
            $NodeArray = @()
            $NodeResponse = Invoke-RundeckMethod -Uri $URI -Headers $Headers
            $NodeResponse | Get-Member -MemberType NoteProperty | ForEach-Object {
                $NodeObject = @(ForEach ($Node in $NodeResponse) {
                    $Obj = @()
                    $Obj = New-Object -Type PSObject -Property @{
                        NodeName    = $Node.$($PSItem.Name).nodename
                        ServerName  = $Node.$($PSItem.Name).hostname
                        Label       = $Node.$($PSItem.Name).label
                        Description = $Node.$($PSItem.Name).description
                        UserName    = $Node.$($PSItem.Name).username
                        Tags        = $Node.$($PSItem.Name).tags
                        Location    = $Node.$($PSItem.Name).location
                    }
                    $NodeArray += $Obj
                })
            }
            $NodeArray
        }
        Catch
        {
            Write-Output "Ran into an issue getting Rundeck Nodes: $($PSItem.ToString())"
        }
    }
}