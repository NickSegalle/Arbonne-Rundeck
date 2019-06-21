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
Function Install-OpenSSH {
    [CmdletBinding()]
    [OutputType([int])]
    param()
    process {
        Try{
            Write-Verbose -Message "Downloading OpenSSH from github.com"
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $url = 'https://github.com/PowerShell/Win32-OpenSSH/releases/latest/'
            $request = [System.Net.WebRequest]::Create($url)
            $request.AllowAutoRedirect=$false
            $response=$request.GetResponse()
            $DownloadURL = $([String]$response.GetResponseHeader("Location")).Replace('tag','download') + '/OpenSSH-Win64.zip' 
            If(!(Test-Path 'C:\Temp')){
                New-Item -Path 'C:\Temp' -ItemType Directory
            }
            Invoke-WebRequest -Uri $DownloadURL -OutFile 'C:\Temp\OpenSSH-Win64.zip'
            Expand-Archive -Path 'C:\Temp\OpenSSH-Win64.zip' -DestinationPath 'C:\Temp\OpenSSH'
            Write-Verbose -Message "Installing OpenSSH"
            If(!(Test-Path 'C:\Program Files\OpenSSH')){
                New-Item -Path 'C:\Program Files\OpenSSH' -ItemType Directory
            }
            Copy-Item -Path 'C:\Temp\OpenSSH\OpenSSH-Win64\*' -Destination 'C:\Program Files\OpenSSH' -Recurse
            Remove-Item -Path 'C:\Temp\OpenSSH-Win64.zip' -Force
            Remove-Item -Path 'C:\Temp\OpenSSH' -Recurse -Force
        }
        Catch {
            Write-Verbose -Message "Error downloading OpenSSH"
            Throw $PSCmdlet.WriteError($_)
        }
        Try{
            Write-Verbose -Message "Starting OpenSSH Services"
            & "C:\Program Files\OpenSSH\install-sshd.ps1"
            New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
            Start-Service sshd
            Set-Service sshd -StartupType Automatic
        }
        Catch {
            Write-Verbose -Message "Error Installing OpenSSH"
            Throw $PSCmdlet.WriteError($_)
        }
    }
}