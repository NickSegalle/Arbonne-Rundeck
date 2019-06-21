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
Function New-SSHKey {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $KeyFormat = 'pem',
        [Parameter(Mandatory=$false)]
        [string]
        $KeyType = 'rsa',
        [Parameter(Mandatory=$false)]
        [Int]
        $KeyLength = '4096',
        [Parameter(Mandatory=$false)]
        [string]
        $KeyComment = $ENV:USERNAME,
        [Parameter(Mandatory=$false)]
        [string]
        $KeyOutput = -join ("C:\Temp\$ENV:USERNAME", "-RSA")
    )

    Process {
            #Check for OpenSSH Install
            If(!(Test-Path 'C:\Program Files\OpenSSH')){
                Install-OpenSSH
            }
            Try
            {
                If(!(Test-Path 'C:\Temp')){
                    New-Item -Path 'C:\Temp' -ItemType Directory
                }
                If(Test-Path $KeyOutput){
                    Remove-Item $KeyOutput -Force -Confirm:$False
                }
                $pubKey = -join ($KeyOutput, ".pub")
                If(Test-Path $pubKey){
                    Remove-Item $pubKey -Force -Confirm:$False
                }

                & "C:\Program Files\OpenSSH\ssh-keygen.exe" -m $KeyFormat -t $KeyType -C "$KeyComment" -f "$KeyOutput" -P """" | Out-Null
                
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
                Write-Verbose -Message "Updating authorized keys with newly created public key!"
                $PublicKeyText = Get-Content (-join ($KeyOutput, ".pub"))
                If(!(Test-Path "$env:USERPROFILE\.ssh\authorized_keys"))
                {
                    New-Item -Path "$env:USERPROFILE\.ssh" -Name "authorized_keys" -Value $PublicKeyText
                }
                ElseIf (Test-Path "$env:USERPROFILE\.ssh\authorized_keys")
                {
                    Add-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value "`n$PublicKeyText"
                }
                $PrivateKeyText = Get-Content $KeyOutput
                Write-Output "Here is the private Key, store it in a safe place!" -ForegroundColor Yellow
                Write-Output $PrivateKeyText -ForegroundColor Red
            }
            Catch 
            {
                Write-Verbose -Message "Error creating SSH Key"
                Throw $PSCmdlet.WriteError($_)
            }
        }
}

