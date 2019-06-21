Install-Module RundeckPS -Repository ArbonnePSRepository
Import-Module RundeckPS

$CommandsToExport = @()
Function Invoke-RD_ReplicateAD {
    <#
    .SYNOPSIS
        Invoke-RD_ReplicateAD
    .EXAMPLE
        !ra aw
    .EXAMPLE
        !repad arbonnewest.com
    .EXAMPLE
        !Invoke-RD_ReplicateAD -Domain arbonnewest.com
    #>
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'ReplicateAD',
        Aliases = ('ra','repad'),
        Permissions = 'execute'
    )]
    param(
        [parameter(Mandatory)]
        $Bot,
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateSet("arbonnewest.com", "aw", "au.arbonneintl.ad", "au", "ca.arbonneintl.ad", "ca", "uk.arbonneintl.ad", "uk" )]
        [String[]]
        $Domain,
        [hashtable] $Headers = $Script:RDHeader
    )
    $JobID = '816a9042-4e94-4a07-b287-b754e8b11a3a'
    Switch ( $Domain )
    {
        "aw"
        {
            $DomainName    = "arbonnewest.com"
        }
        "au"
        {
            $DomainName    = "au.arbonneintl.ad"
        }
        "ca"
        {
            $DomainName    = "ca.arbonneintl.ad"
        }
        "uk"
        {
            $DomainName    = "uk.arbonneintl.ad"
        }
    }
    $JobBody = @{
        loglevel = "INFO" 
        asUser   = $Bot.Backend.UserIdToUsername($_.Message.From)
        options  =  @{
            DomainName   = "$DomainName"
            }
    }
    $JobBodyJson = $JobBody | ConvertTo-Json

    #Execute the job
    Try 
    {
        $RunResult = Invoke-RDJob -JobID $JobID -Body $JobBodyJson
    }
    Catch 
    {
        $ErrorOutput = Write-Output "Ran into an issue runinng the Rundeck Job: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }

    #Wait for output to send back to Teams
    Try 
    {
        While((Get-RDExecutionState -ExecutionID $RunResult.id).executionState -eq "RUNNING" -OR (Get-RDExecutionState -ExecutionID $RunResult.id).executionState -eq "WAITING")
        {
            Start-Sleep -Seconds 3
        }
        (Get-RDExecutionState -ExecutionID $RunResult.id).executionState
    }
    Catch 
    {
        $ErrorOutput = Write-Output "Ran into an issue waiting for Rundeck job results: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }

    Try
    {
        $Output            = Get-RDExecutionOutput -ExecutionID $RunResult.id 
        $OutputLog         = $Output.entries | Select-Object time,log -Last 10 | Format-Table -autosize | Out-String
        $OutputResultState = (Get-RDExecutionState -ExecutionID $RunResult.id).executionState
        New-PoshBotCardResponse -Type Normal -Text "$OutputLog `n The command completed with the following result: $OutputResultState"
    }
    Catch 
    {
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
    }
}

$CommandsToExport += 'Invoke-RD_ReplicateAD'

Export-ModuleMember -Function $CommandsToExport

$JobBodyJson = $JobBody | ConvertTo-Json
Invoke-RDJob -JobID $JobID -Body $JobBodyJson

$JobBody = @{
    loglevel = "INFO" 
    asUser   = "test"
    options  =  @{
        DomainName   = "arbonnewest.com"
        }
}