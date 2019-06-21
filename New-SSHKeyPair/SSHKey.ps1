


<#
    1. 
    1. Service account opens PSRemoting
        a. Copy SSH Files / Install SSH (Choco or long term would be NuGet Repo)
        b. Check for profile / check for ssh services
    3. Generates SSH Key Pair
    4. Copy Public Key to authorize_keys of that service account (%USERNAME%\.ssh\authorized_keys)
    6. Takes Private Key and puts it into RunDeck via API
        a. 
    2. Closes PSRemoting
#>




# 1. Service account opens PSRemoting
# 2. Closes PSRemoting
# 3. Generates SSH Key Pair
# 4. Creates %USERNAME%\.ssh\authorized_keys
# 5. Takes Public Key and places it that file
# 6. Takes Private Key and puts it into RunDeck.

<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
function Initialize-SSHKey {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory=$True)]
        [string]
        $ComputerName,
        [Parameter(Mandatory=$False)]
        [System.Management.Automation.PSCredential]
        $ServiceAccountCredential = (Get-Credential -Message "Please enter the username and password for the service account used on the node."),
        [Parameter(Mandatory=$False)]
        [System.Management.Automation.PSCredential]
        $UserCredential = (Get-Credential -Message "Please enter the username and password for the initial connection")
    )

    process {

        #Check for OpenSSH on Remote Host

        #Check for Profile on Remote Host

        #Install OpenSSH
    }
    

}

