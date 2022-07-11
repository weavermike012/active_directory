param( [Parameter(Mandatory=$true)] $JSONFile )

function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )
    
    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}

function CreateADUser(){
    param( [Parameter(Mandatory=$true)] $userObject )

    #Pull the name out from the JSON object ad_schema.json
    $name = $userObject.name
    $password = $userObject.password

    # Generate a "first initial, lastname" structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username

    # Creates the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 

    # Add the user to its appropriate group 
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT ADDED TO GROUP $group_name because it doesn't exit"    
        }
    }
}


$json = ( Get-Content $JSONFile | ConvertFrom-JSON )

$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
    CreateADGroup $group
}

foreach ( $user in $json.users ){
    CreateADUser $user
}