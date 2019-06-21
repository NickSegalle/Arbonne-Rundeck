
Function Invoke-RundeckMethod(){
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
        ValueFromPipeline    = $True,
        ValueFromPipelinebyPropertyName=$True)]
        [String] $URI,
        [Parameter(Mandatory = $False)]
        [String] $Body,
        [Parameter(Mandatory = $False)]
        [Hashtable] $Headers,
        [Parameter(Mandatory = $False)]
        [String] $ContentType = 'application/json'
    )
    Process{
        Try
        {
            If (!$Body)
            {
                Invoke-RestMethod -Uri $URI -Headers $Headers
            }
            Else
            {
                Invoke-RestMethod -Uri $URI -Body $Body -Headers $Headers -Method Post
            }
        }
        Catch
        {
            Write-Output "Ran into an issue: $($PSItem.ToString())"
        }
    }
}