# Criação de Usuários no Active Directory
Script para criação de usuários no Active Directory utilizando a ferramenta Windows PowerShell. 

## Importação do CSV
O Script recebe os dados de um arquivo CSV delimitado por vírgulas. <br>
```
Import-csv nome_do_arquivo.csv -Delimiter "," 
```
Um modelo do arquivo CSV pode ser encontrado [aqui](https://github.com/mayconreis/criacao-usuarios-active-directory/blob/80ca447f6416b4a2a274be85d72f5306935a4099/base_criacao.csv).

## Links Úteis
[Active Directory Cmdlets no Windows PowerShell](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ee617195(v=technet.10)?redirectedfrom=MSDN)
