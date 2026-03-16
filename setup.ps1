Set-ExecutionPolicy RemoteSigned
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
    {  
      $arguments = "& '" +$myinvocation.mycommand.definition + "'"
      Start-Process powershell -Verb runAs -ArgumentList $arguments
      Break
    }
#Fonctionnement du script
#Appeler la fonction CreateKey et lui donner le chemin, le nom du dossier a créer au besoin, le Nom de la clé et la Valeur
#Par défaut les clés sont créer en Dword et les valeurs sont en hexadecimal
#Attention, on force la modification de la clé
function CreateKey {
  param (
    [Parameter(mandatory=$true)][String]$Chemin,
    [String]$Dossier,
    [Parameter(mandatory=$true)][String]$Nom,
    [Parameter(mandatory=$true)][Int]$Valeur,
    [String]$Type
)

if($Dossier){ #Si Dossier n'est pas null
  New-Item -Path $Chemin -Name $Dossier
  Set-Location "$Chemin\$Dossier"
  $Chemin = "$Chemin\$Dossier"
}
New-ItemProperty -Path $Chemin -Name $Nom -Value $Valeur -PropertyType $Type -force
}

CreateKey -Chemin "HKCU:\Software\Policies\Microsoft\Windows" -Dossier "Explorer" -Nom "DisableSearchBoxSuggestions" -Valeur 1 #Enleve recherche web
CreateKey -Chemin "HKCU:\Control Panel\Desktop" -Nom "MenuShowDelay" -Type String -Valeur 100 #change delais d'ouverture de fenetres
CreateKey -Chemin "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Nom "HideFileExt" -Valeur 0 #Montre les extensions de fichiers
CreateKey -Chemin "HKLM:\Software\Policies\Microsoft" -Dossier "Dsh" -Nom "AllowNewsAndInterests" -Valeur 0 # Désactive les widgets
CreateKey -Chemin "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Dossier "Serialize" -Nom "Startupdelayinmsec" -Valeur 0 # Baisse le délai de lancement des applications au démarrage a 1s au lieu de 10sec 

Read-Host -Prompt "termine!"


