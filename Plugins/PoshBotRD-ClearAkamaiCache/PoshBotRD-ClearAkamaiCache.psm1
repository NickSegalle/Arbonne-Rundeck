
$CommandsToExport = @()
Function Invoke-AkamaiClearCache {
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
        CommandName = 'AkamaiClearCache',
        Aliases = ('acc','akamaiclear'),
        Permissions = 'execute'
    )]
    param(
        [parameter(Mandatory = $False)]
        [string] $URL = 'http://www.arbonne.com/pws/PublicStore/26-9552-Everything_CatalogImage.image.ashx'
    )
    $Body = @{
        objects = @("http://www.arbonne.com/pws/PublicStore/26-9552-Everything_CatalogImage.image.ashx")
    }
    
    $JSONBody = $Body | ConvertTo-Json
    
    $AkamaiParameters = @{
        Method            = "POST"
        ClientToken       = "akab-44epdb4uxyw67izr-ymeql2aqclgtezoj"
        ClientAccessToken = "akab-gthglvs7z3qgkp4v-mgk7fc3svbgvqcli"
        ClientSecret      = "LIduikRyg9zF7VwNr0ejGu+3iENNRAFVILlvoVJg6MA="
        ReqURL            = "https://akab-x752c2z4lvhwn7og-gvmmzl2d32ecb24t.purge.akamaiapis.net/ccu/v3/delete/url/production"
    }
    Try
    {
        $Results = Invoke-AkamaiOPEN @AkamaiParameters -Body $JSONBody
        New-PoshBotCardResponse -Type Normal -Text $Results
    }
    Catch
    {
        $ErrorOutput = Write-Output "Ran into an issue runinng the command: $($PSItem.ToString())"
        New-PoshBotCardResponse -Type Normal -Text $ErrorOutput
        Break
    }
}

$CommandsToExport += 'Invoke-AkamaiClearCache'

Export-ModuleMember -Function $CommandsToExport
