# 01 Installing Domain Controller
1. User `sconfig` to:
    - Change the hostname
    - Change the ip Addr to static 192.168.1.160
    - Change DNS Server to own IP/Secondary to 192.168.1.1

##    ((Enter Remote Session on management console))
`Enter-PSSession 192.168.1.160 -Credential (Get-Credential)`

2. Install The Active Directory Windows Feature

```shell
`Install-WindowsFeature AD-Domain-Servives -Include ManagementTools`

```
3. Import the Active Directory Domain Services Deployment Module
```shell
`Import-Module ADDSDeployment`
```

4. Install Active Directory Domain Services Forest maw.com

```shell
`Install-ADDSForest`
```
5. Joining workstation1 to domain

```shell
`Add-Computer -Domainname maw.com -Credential MAW\Administrator -Force -Restart`
