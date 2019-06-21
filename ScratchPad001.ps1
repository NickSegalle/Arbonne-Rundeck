
$JobBody = @{
    loglevel = "INFO" 
    asUser   = "nsegalle"
    filter   = "tags: Local"
    options  =  @{
        RundeckProjectName           = 'RDInfra'
        NewNodeName                  = 'USZIN-RDNODE-01-SVC-RD_RDInfra'
        NewNodeHostName              = 'USZIN-RDNODE-01'
        AdministratorAccountName     = 'adm-nsegalle'
        AdministratorAccountPassword = ''
        ServiceAccountName           = 'SVC-RD_RDInfra'
        ServiceAccountPassword       = '6V!h7!P3oa432rdhj6!qI'
        NewNodeDescription           = 'USZIN-RDNODE-01 for RDInfra Project'
        NewNodeTags                  = 'tags="Zayo Irvine, CorpNonProd"'
        }
}

$Job = Get-RDJob -JobID 5fc977ad-7e3a-4898-93d7-9101e7ace8d9

# $Job.joblist.job.context.options.option | ft -autosize

$JobID  =  '5fc977ad-7e3a-4898-93d7-9101e7ace8d9'
    if($format -eq "XML")
    {
        $URI = "$BaseURI/job/$JobID`?format=xml"
    }
    else
    {
        $URI = "$BaseURI/job/$JobID`?format=yaml"
    }
    $Result = WS-GetReq -Header $Header -URI $URI
    $Result


Get-RDProjectList | %{Get-RDNodeList -ProjectName $PSItem.ProjectName}

Get-RDProjectList | %{Get-RDNodeList -ProjectName $PSItem.ProjectName} | Select-Object ServerName -Unique




$JobBody = @{
    loglevel = "INFO" 
    asUser   = "nsegalle"
    filter   = "USZIN-RDNODE-01-SVC-RD_ServiceDesk"
    options  =  @{
        DomainName  = 'arbonnewest.com'
        }
}


Invoke-RDJob -JobID '5fc977ad-7e3a-4898-93d7-9101e7ace8d9' -Body $JobBodyJson

