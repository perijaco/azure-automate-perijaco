
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "URL til kortstokk")]
        [String]
        $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle' 
 )
    

# Stopper kjøring av scriptet ved feil
$ErrorActionPreference = 'Stop'

$webrequest = Invoke-WebRequest -Uri http://nav-deckofcards.herokuapp.com/shuffle

$kortstokkJson = $webrequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

 function kortstokkTilStreng{
     [outputType([string])]
     param (
         [Object[]]
         $kortstokk
     )
     $streng = ""
     foreach ($kort in $kortstokk){
         $streng += "$($kort.suit[0])" + "$($kort.value)" + ","
     }
     return $streng.TrimEnd(",")
 }
function SumPoengKortstokk {
    [OutputType([Int])]
    param (
        [System.Object[]]  
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        $poengKortstokk += switch ($kort.value) {
             { $_ -cin @('J', 'Q' , 'K') } {10}
             'A' {11}
            Default {$kort.value}
        }
        
    }
   return $poengKortstokk
}



Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"
Write-Host "Poengsum av kortene: $(sumpoengkortstokk -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]
$Magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]

write-host "Mine kort: $(kortstokkTilStreng($meg))"
write-host "Magnus kort: $(kortstokkTilStreng($Magnus))"
write-host "Kortstokk : $(kortstokkTilStreng -kortstokk $kortstokk)"