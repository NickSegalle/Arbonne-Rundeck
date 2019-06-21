Install-Module RundeckPS -Repository ArbonnePSRepository
Import-Module RundeckPS

$CommandsToExport = @()
Function Invoke-RecycleIISAppPoolProd {
    <#
    .SYNOPSIS
        Invoke-RecycleIISAppPoolProd
    .EXAMPLE
        !irapprod USAVR-PWSWEB-01
    .EXAMPLE
        !recycleapoolprod USAVR-PWSWEB-01, USAVR-PWSWEB-02
    .EXAMPLE
        !Invoke-RecycleIISAppPoolProd -Server USAVR-PWSWEB-01, USAVR-PWSWEB-02
    #>
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'RecycleAPoolProd',
        Aliases = ('irapprod','recycleapoolprod'),
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
        [hashtable] $Headers = '',
        [switch] $Wait
    )

    # $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    # $Headers.Add("Accept", "application/json")
    # $Headers.Add("Content-Type", "application/json")
    # $Headers.Add("X-Rundeck-Auth-Token", "$APIToken")

    $APIToken  = "SLxLAX62ubimpK5V9KbAG43kMzTZIDc0"
    $APIVersion = "30"
    $Script:RundeckServer = "rdprod.arbonne.aws"
    $Script:RundeckBaseURI = "https://$RundeckServer/api/$APIVersion"
    $Script:RDAWSHeader = New-RDAuthHeader -APIToken $APIToken
    $Script:RDAWSHeader
    $JobID = '59263e19-7c7f-4e15-81e9-760f50f1ed1d'

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
        $RunResult = Invoke-RDJob -JobID $JobID -Body $JobBodyJson -Headers $RDAWSHeader
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
        While((Get-RDExecutionState -ExecutionID $RunResult.id -Headers $RDAWSHeader).executionState -eq "RUNNING" -OR (Get-RDExecutionState -ExecutionID $RunResult.id -Headers $RDAWSHeader).executionState -eq "WAITING")
        {
            Start-Sleep -Seconds 3
        }
        (Get-RDExecutionState -ExecutionID $RunResult.id -Headers $RDAWSHeader).executionState
    }
    Catch 
    {
        $ErrorOutput = Write-Output "Ran into an issue waiting for Rundeck job results: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }

    Try
    {
        $Output            = Get-RDExecutionOutput -ExecutionID $RunResult.id -Headers $RDAWSHeader
        $OutputLog         = $Output.entries | Select-Object time,log -Last 10 | Format-Table -autosize | Out-String
        $OutputResultState = (Get-RDExecutionState -ExecutionID $RunResult.id -Headers $RDAWSHeader).executionState
        New-PoshBotCardResponse -Type Normal -Text "$OutputLog `n The command completed with the following result: $OutputResultState"
    }
    Catch 
    {
        $ErrorOutput = Write-Output "Ran into an issue outputting the results: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }
}

$CommandsToExport += 'Invoke-RecycleIISAppPoolProd'

Export-ModuleMember -Function $CommandsToExport
