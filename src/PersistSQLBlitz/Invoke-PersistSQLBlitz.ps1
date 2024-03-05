<#
.Synopsis
	Will persist the SQL First Responder data by calling sp_BlitzFirst every 5 minutes
.DESCRIPTION
	
#>
param( 
    $promMetricPath = "/mnt/prom"
    ,$logLevel = "Debug"
    )

Import-Module dbatools,fc_core,fc_log -Force -DisableNameChecking

Set-LogLevel $logLevel

$exceptionCount = 0
if([string]::IsNullOrEmpty($promMetricPath)){
    $promMetricPath = "$PSScriptRoot\prom"
}
    $StaticLabels = @("SupportTeam=`"DBA`"")
    $metrics = @(
        @{Name="data_instance_start_total"; Description="How many jobs have started";type="gauge"; value="1";labels=$StaticLabels}
    )
    Invoke-PrometheusMetricFile -metrics $metrics -textFileDir $promMetricPath

    Set-LogFormattingOptions -PrefixCallingFunction 1 -PrefixTimestamp 1 -PrefixScriptName 1


$query = "EXEC sp_BlitzFirst
@OutputDatabaseName = 'dba'
, @OutputSchemaName = 'dbo'
, @OutputTableName = 'First'
, @OutputTableNameFileStats = 'First_FileStats'
, @OutputTableNamePerfmonStats = 'First_PerfmonStats'
, @OutputTableNameWaitStats = 'First_WaitStats'
, @OutputTableNameBlitzCache = null
, @OutputTableNameBlitzWho = 'Who'
, @OutputType = 'none'"
try{

    $sqlInstance = 'ms_sql'
    Write-Log "Executing for $sqlInstance"
    Write-Log "query: $Query" Debug
	$sqlPass = [Environment]::GetEnvironmentVariable('MSSQL_SA_PASSWORD') | ConvertTo-SecureString -AsPlainText -Force
	if([string]::IsNullOrEmpty($sqlPass)){
		Write-Log "Could not get the SQL auth password from the MSSQL_SA_PASSWORD env variable" Error -ErrorAction Stop
	}
	Set-DbatoolsInsecureConnection
	$sqlCred = new-object -typename System.Management.Automation.PSCredential `
	-argumentlist 'sa', $sqlPass
    Invoke-DBAQuery -SqlInstance $sqlInstance -Database 'dba' -SqlCredential $sqlCred -Query $query -EnableException -ErrorAction Stop
}
catch{
    
    $ex = $_.Exception
    Write-Log "Error: $ex"
     if ([string]::IsNullOrEmpty($_.InvocationInfo.ScriptName)) { 
        $scriptName = "[No InvocationInfo Available]" 
        $line = 0
    }
     else { 
        $scriptName = Split-Path $_.InvocationInfo.ScriptName -Leaf 
        $line = $_.InvocationInfo.ScriptLineNumber
    }
    
     $msg = $ex.Message

     Write-Log "Error in script $scriptName at line $line, error message: $ex" Error -ErrorAction Stop 
     $exceptionCount++
    }
    finally{
        $metrics += @(
            ,@{Name="data_exceptions_count_total"; Description="How many exceptions were thrown";type="gauge"; value="$exceptionCount";labels=$StaticLabels}
        )
    
        Invoke-PrometheusBatchEnding -textFileDir $promMetricPath -SLO_InstanceShouldRunEveryXSeconds 900 -domain 'test' -metrics $metrics # Should run every 15 minutes
    }
    Write-Log "Done"
	sleep (5*60)