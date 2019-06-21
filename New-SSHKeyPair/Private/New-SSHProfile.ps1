
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
function New-RemoteSSHProfile {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory=$True)]
        [string]
        $ComputerName,
        [Parameter(Mandatory=$False)]
        [System.Management.Automation.PSCredential]
        $UserCredential = (Get-Credential -Message "Please enter the username and password for the service account used on the node.")
    )
    # begin {
    # }
    process {

        If(!(Test-Path $env:USERPROFILE\.ssh))
        {
            Write-Verbose -Message "SSH path does not exist, creating now..."
            Try {
                New-Item $env:USERPROFILE\.ssh -ItemType Directory
            }
            Catch {
                Write-Verbose -Message "Error creating SSH Key"
                Throw $PSCmdlet.WriteError($_)
            }
            Write-Verbose -Message "SSH path created successfully!"
        }
        Else 
        {
            Write-Verbose -Message "SSH path exists, continuing..."
        } 
    }
}