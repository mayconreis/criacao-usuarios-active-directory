# Importa modulo do Active Directory
Import-Module activedirectory  
Get-Date >> "Usuarios_criados.txt"
#Armazena o arquivo nomes.csv na variavel $ADUsers
$ADUsers = Import-csv base_cricao.csv -Delimiter "," 

#Loop por linha com os detalhes do usuário no arquivo csv 
foreach ($User in $ADUsers)
{
    #Gera uma senha aleatória para o colaborador
    $Comprimento = 8
    $Caracteres = 'qazwsxedcrfvtgbyhnujmikolpQAZWSXEDCRFVTGBYHNUJMIKOLP0123456789$%&amp;?*#'
    $Senha = -join ($Caracteres.ToCharArray() | Get-Random -Count $Comprimento)

    #Le o usuario na variavel $User e armazena as informações nas variaveis
    $Username   = $User.username
    $Password   = $Senha
    $Firstname  = $User.firstname
    $Copy       = $User.copy
    $Lastname   = $User.lastname
    $NomeUserCopia = Get-ADUser -Identity "$Copy" | Select name
    $NomeUserCopia = "$NomeUserCopia".replace("@{Name=","") 
    $NomeUserCopia = "$NomeUserCopia".replace("}","")  
    $CaminhoUserCopia = Get-ADUser -Identity "$Copy" | Select DistinguishedName
    $CaminhoUserCopia = "$CaminhoUserCopia".replace("@{DistinguishedName=CN=$NomeUserCopia,","")
    $CaminhoUserCopia = "$CaminhoUserCopia".replace("}","")
    $OU = "$CaminhoUserCopia"
 #  Caminho onde será criado o usuário no AD
    $email      = $User.email
 #  $streetaddress = $User.streetaddress
 #  $city       = $User.city
 #  $zipcode    = $User.zipcode
 #  $state      = $User.state
 #  $country    = $User.country
 #  $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
 #  $company    = $User.company
    $department = $User.department
 #  $Password = $User.password

 #  Write-Output = $OU

    #Verifica se o usuário ja existe no AD
    try
    {
        $UsuarioExiste = Get-ADUser $Username -ErrorAction Stop
        #Se o usuário existir apresenta o alerta abaixo
        Write-Output "Um usuário com o nome $Username já existe no Active Directory."
    }
    catch
    {
        try
        {
            Write-Output "Criando o usuário $Username"
            #Caso o usuário não exista, seguir com a criação da conta
            New-ADUser -Name "$Firstname $Lastname" `
            -Path "$OU" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -SamAccountName $Username `
            -DisplayName "$Firstname $Lastname" `
            -Department $department `
            -UserPrincipalName "$Username@MLTBR.LOCAL"`
            -Title $jobtitle `
            -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -ChangePasswordAtLogon $True `
            -Enabled $True `
            -EmailAddress $email
            #ErrorAction Stop-PasswordNeverExpires $True
            
            Set-ADUser -Identity $Username -ChangePasswordAtLogon $False -PasswordNeverExpires $True

            $user_create = "User: $Username Senha: $Password"
            $user_create >> "Usuarios_criados.txt"
            $groups = Get-ADPrincipalGroupMembership -Identity "$Copy" | select name
            foreach ($group in $groups)
            {
                $group = "$group".replace("@{name=", "")
                $group = $group.replace("}", "")
                ADD-ADGroupMember "$group" -members "$Username"
            }
        }
        catch
        {
            Write-Output "Não foi possível criar o usuário no AD."
        }
    }

}