<#
    .Synopsis
        For starting PowerShell with the SYSTEM account.

    .Description
        This script uses PsExec from Sysinternals Live to open a PowerShell command window using the SYSTEM account. The new process will be 
        started with administrative privileges.

    .Link
        https://blogs.technet.microsoft.com/heyscriptingguy/2011/09/15/scripting-wife-uses-powershell-to-update-sysinternals-tools/

    .Link
        https://gallery.technet.microsoft.com/scriptcenter/a22c7355-5d18-468e-be9e-5d3efeaafb98
#>



$PoShExe = "$Env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe"
$SysinternalsLivePath = "\\live.sysinternals.com\tools"
if ([Environment]::Is64BitProcess) {
    $PsExecExe = "PsExec64.exe"
}
else {
    if ([System.Environment]::Is64BitOperatingSystem) { # to keep PowerShell 32-bit if script started as 32-bit on 64-bit OS
        $PoShExe = "$Env:SystemRoot\syswow64\WindowsPowerShell\v1.0\powershell.exe"
    }
    $PsExecExe = "PsExec.exe"
}
$PsExecPath = "$SysinternalsLivePath\$PsExecExe"



Write-Output "Connecting to Sysinternals Live..."
Test-Path -Path $SysinternalsLivePath | Out-Null



Write-Output "Starting PSExec..."
$env:SEE_MASK_NOZONECHECKS = 1 # to disable the "Open File - Security Warning" dialog - https://www.wintellect.com/handling-open-file-security-warning/
Start-Process -FilePath $PsExecPath -ArgumentList "-AcceptEula -NoBanner -s -i -d $PoShExe" -Verb "RunAs"
Remove-Item Env:\SEE_MASK_NOZONECHECKS