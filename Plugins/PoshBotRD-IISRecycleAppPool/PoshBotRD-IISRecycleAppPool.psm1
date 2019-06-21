Install-Module RundeckPS -Repository ArbonnePSRepository
Import-Module RundeckPS

$CommandsToExport = @()
Function Invoke-RecycleIISAppPool {
    <#
    .SYNOPSIS
        Invoke-RecycleIISAppPool
    .EXAMPLE
        !irap USAVR-PWSWEB-01
    .EXAMPLE
        !recycleapool USAVR-PWSWEB-01, USAVR-PWSWEB-02
    .EXAMPLE
        !Invoke-RecycleIISAppPool -Server USAVR-PWSWEB-01, USAVR-PWSWEB-02
    #>
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'RecycleAPool',
        Aliases = ('irap','recycleapool'),
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
    $JobID = '9feb6fc8-fd70-40d8-b244-9c3e44294fb5'
    If (!$PoshBotContext.FromName){
        New-PoshBotCardResponse -Type Normal -Text "PoshBot is unable to determine the your user name and cannot execute the command."
        Break
    }
    Else {
        $FromName = $PoshBotContext.FromName
    }
    $JobBody = @{
        loglevel = "INFO" 
        asUser   = $FromName
        options  =  @{
            ServerName   = "$Server"
            }
    }
    $JobBodyJson = $JobBody | ConvertTo-Json

    #Execute the job
    Try 
    {
        $RunResult = Invoke-RDJob -JobID $JobID -Body $JobBodyJson
        If (!$Wait)
        {
            New-PoshBotCardResponse -Type Normal -Text "Started Rundeck Job to recycle the app pool on the specified servers: `n `n $Server `n `n  Job ID: $($RunResult.id). `n"
            Break
        }
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
        New-PoshBotCardResponse -Type Normal -Text "Started Rundeck Job to recycle the app pool on the specified servers: `n `n $Server `n `n  Job ID: $($RunResult.id). `n Waiting for results, stand by..."
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
        $ErrorOutput = Write-Output "Ran into an issue outputting the results: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }
}

$CommandsToExport += 'Invoke-RecycleIISAppPool'

Export-ModuleMember -Function $CommandsToExport
