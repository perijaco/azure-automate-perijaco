
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "URL til kortstokk")]
        [String]
        $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle' 
 )
    
$sum = 17
# Stopper kjøring av scriptet ved feil
$ErrorActionPreference = 'Stop'
$webrequest = Invoke-WebRequest -Uri 'https://azure-gvs-test-cases.azurewebsites.net/api/taperMeg'
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
function SkrivUtResultat {
    param (
        [string]
        $Vinner,
        [Object[]]
        $kortStokkMagnus,
        [Object[]]
        $Kortstokkmeg
    )
    Write-Host "Vinner er : $Vinner"
    Write-Host "Magnus : | $(SumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortstokkTilStreng -kortstokk $kortStokkMagnus)"
    Write-Host "Meg :   | $(sumpoengkortstokk -kortstokk $Kortstokkmeg) |  $(kortstokkTilStreng -kortstokk $Kortstokkmeg)"
}



Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"
Write-Host "Poengsum av kortene: $(sumpoengkortstokk -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]
$Magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Length]

#write-host "Mine kort: $(kortstokkTilStreng($meg))"
#write-host "Magnus kort: $(kortstokkTilStreng($Magnus))"
#write-host "Kortstokk : $(kortstokkTilStreng -kortstokk $kortstokk)"


#Definerer variabel Blackjack til 21
$Blackjack = 21


if (((SumPoengKortstokk -kortstokk $Magnus) -eq $Blackjack) -and ((SumPoengKortstokk -kortstokk $meg) -eq $Blackjack)){
SkrivUtResultat -Vinner "Uavgjort" -kortStokkMagnus $magnus -Kortstokkmeg $meg
exit 
}

elseif ((SumPoengKortstokk -kortstokk $meg) -eq $Blackjack) {
    SkrivUtResultat -Vinner "meg" -kortStokkMagnus $magnus -Kortstokkmeg $meg
    Exit
}

elseif ((SumPoengKortstokk -kortstokk $Magnus) -eq $Blackjack) {
    SkrivUtResultat -Vinner "Magnus" -kortStokkMagnus $magnus -Kortstokkmeg $meg
   Exit 
}

while ((SumPoengKortstokk -kortstokk $meg) -le $sum) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Length]    
}

if ((SumPoengKortstokk -kortstokk $meg) -gt $Blackjack) {
    SkrivUtResultat -Vinner "Magnus" -kortStokkMagnus $Magnus -Kortstokkmeg $meg
    exit
    }