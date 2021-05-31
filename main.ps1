$Computers = "AppleiMacM1"
ForEach ($Computer in $Computers){
    Get-WMIObject -Class win32_product -ComputerName $Computer -ErrorAction Stop |
        Select-Object -Property @{N='Computer';E={$Computer}},Name,Version |
        Export-Csv "C:\SWDTOOLS\Desk.csv" -Append
}

$csv1 = Import-Csv C:\SWDTOOLS\Desk.csv 
$csv2 = Import-Csv C:\SWDTOOLS\LPDP.csv



(Compare-Object -ReferenceObject $csv2 -DifferenceObject $csv1 -PassThru -IncludeEqual  -Property name,Version |
     ForEach-Object {
        $_.SideIndicator = $_.SideIndicator -replace '=>','Logiciels à jour ou + récent' -replace '<=','logiciel non à jour' -replace '==','logiciel à jour'
        $_
    }) | Out-GridView -PassThru -Title 'Comparatif des Logiciels par version'
