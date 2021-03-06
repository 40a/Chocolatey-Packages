$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$customArgs = $env:chocolateyInstallArguments
$env:chocolateyInstallArguments=""
if($customArgs.Length -gt 0){
    $featuresToAdd = -split $customArgs
    [xml]$adminXml=Get-Content $adminFile
    $featuresToAdd | % {
        $feature=$_
        $node=$adminXml.DocumentElement.SelectableItemCustomizations.ChildNodes | ? {$_.Id -eq "$feature"}
        if($node -ne $null){
            $node.Selected="yes"
        }
    }
    $adminXml.Save($adminFile)
}
Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log" 'http://download.microsoft.com/download/C/F/B/CFBB5FF1-0B27-42E0-8141-E4D6DA0B8B13/vs_ultimate_download.exe'
