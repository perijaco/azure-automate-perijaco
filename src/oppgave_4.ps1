
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
Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"