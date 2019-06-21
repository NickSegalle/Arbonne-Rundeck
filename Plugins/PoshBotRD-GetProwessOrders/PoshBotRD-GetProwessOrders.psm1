
$CommandsToExport = @()
Function Get-ProwessOrders {
    <#
    .SYNOPSIS
        Invoke-AkamaiClearCache
    .EXAMPLE
        !akamaiclear URL
    .EXAMPLE
        !acc URL
    .EXAMPLE
        !Invoke-AkamaiClearCache -URL 'http://www.arbonne.com/pws/PublicStore/26-9552-Everything_CatalogImage.image.ashx'
    #>
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'GetProwessOrders',
        Aliases = ('go','getorders'),
        Permissions = 'execute'
    )]
    param(
        [parameter(Mandatory)]
        $Bot,
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Server,
        [parameter(Mandatory = $False)]
        [hashtable] $Headers = $Script:RDHeader,
        [switch] $Wait
    )
    $JobID = 'eae129c3-946f-4ea6-bf95-547e6a477852'
    
   # $channelId = 'Y2lzY29zcGFyazovL3VzL1JPT00vMGQ0MWI2NjAtNTgwMi0xMWU5LWE1ODctZDMxOGM3MWRiZGQ3'
   # $PoshBotContext.channelId = 'Y2lzY29zcGFyazovL3VzL1JPT00vMGQ0MWI2NjAtNTgwMi0xMWU5LWE1ODctZDMxOGM3MWRiZGQ3'

    If (!$PoshBotContext.FromName){
        New-PoshBotCardResponse -Type Normal -Text "PoshBot is unable to determine the your user name and cannot execute the command."
        Break
    }
    Else {
        $FromName = $PoshBotContext.FromName
    }

    $RoomId = $PoshBotContext.channelId

    $JobBody = @{
        loglevel = "INFO" 
        asUser   = $FromName
        options  =  @{
            RoomID   = "$($RoomId)"
            }
    }
    $JobBodyJson = $JobBody | ConvertTo-Json

    Try 
    {
        $RunResult = Invoke-RDJob -JobID $JobID -Body $JobBodyJson
        New-PoshBotCardResponse -Type Normal -Text "Started Rundeck Job to show orders `n `n  Job ID: $($RunResult.id). `n"
        Break
    }
    Catch 
    {
        $ErrorOutput = Write-Output "Ran into an issue runinng the Rundeck Job: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }
}

$CommandsToExport += 'Get-ProwessOrders'

Export-ModuleMember -Function $CommandsToExport
