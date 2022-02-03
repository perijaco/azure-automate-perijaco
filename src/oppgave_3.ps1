# Stopper kjøring av scriptet ved feil
$ErrorActionPreference = 'Stop'

$webrequest = Invoke-WebRequest -Uri http://nav-deckofcards.herokuapp.com/shuffle

$kortstokkJson = $webrequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson


#Sjekker alle kort i stokken og skriver ut første bokstav i type og verdi på kort
#foreach ($kort in $kortstokk)
 #{Write-Output "$($kort.suit[0])+$($kort.value)"}

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