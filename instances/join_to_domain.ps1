$domainName = ""      #domain name
$domainUser = ""          #admin username
$domainPassword = ""      #admin password
$ouPath = "OU=Computers,DC=,DC=com"  #OU

#join the domain
Add-Computer -DomainName $domainName -Credential (New-Object System.Management.Automation.PSCredential("$domainName\$domainUser", (ConvertTo-SecureString $domainPassword -AsPlainText -Force))) -OUPath $ouPath -Restart

#gcloud compute instances create VM_NAME `
#  --image-project=windows-cloud `
#  --image-family=windows-2019-core `
#  --metadata=windows-startup-script-ps1='Import-Module servermanager
#  Install-WindowsFeature Web-Server -IncludeAllSubFeature
#  "<html><body><p>Windows startup script added directly.</p></body></html>" > C:\inetpub\wwwroot\index.html'