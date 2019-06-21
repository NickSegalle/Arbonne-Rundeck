
New-Item -Type Directory -Path ./Plugins/PoshBotRD-IISRecycleAppPool
Set-Location -Path ./Plugins/PoshBotRD-IISRecycleAppPool

$manifestParams = @{
    Path              = './PoshBotRD-IISRecycleAppPool.psd1'
    RootModule        = './PoshBotRD-IISRecycleAppPool.psm1'
    ModuleVersion     = '0.0.1'
    PowerShellVersion = '5.1'
    GUID              = New-Guid
    Author            = 'Nick Segalle'
    Description       = 'Plugin for recycling the app pool with Rundeck'
    Tags              = @('PoshBot', 'Rundeck', 'IISRecycleAppPool')
}

New-ModuleManifest @manifestParams

New-Item -Path ./PoshBotRD-IISRecycleAppPool.psm1