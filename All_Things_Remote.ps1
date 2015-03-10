# -------------------------------------------------------------------------------------------------
#
# Name                  : All_Things_Remote.ps1
# Description           : A collection of remoting functions, utilizing user credentials and
#                         executing scripts remotely.
# Last Modified         : 03-05-2015
# Available Functions   : Create-Credentials
#                         Store-Credentials
#                         Return-StoredCredentials
#                         Invoke-Remotely                        
#
# -------------------------------------------------------------------------------------------------





# -------------------------------------
# returns an object containing user's name/password
# -------------------------------------

function Create-Credentials {
  
  $UserName = Read-Host "UserName: "
  $UserPassword = Read-Host "Password: " -AsSecureString
  $UserCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName,$UserPassword

  return $UserCredentials
  }





# -------------------------------------
# store a user's credentials for remoting
# -------------------------------------

function Store-Credentials {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$true)]
    [string]$PathToStore,
    
    [parameter(mandatory=$false)]
    [object]$CredentialsToStore
    )
  

  if ($CredentialsToStore) {
    $UserName = $CredentialsToStore.UserName
    $UserName | Out-File $PathToStore
    $UserPassword = $CredentialsToStore.Password
    $UserPassword | Out-File $PathToStore -Append    
    }
    else {
      $UserName = Read-Host "UserName: "
      $UserName | Out-File $PathToStore
      $UserPassword = Read-Host "Password: " -AsSecureString | ConvertFrom-SecureString
      $UserPassword | Out-File $PathToStore -Append
      }
  
  }





# -------------------------------------
# return user's credentials from saved filepath location
# -------------------------------------

function Return-StoredCredentials {
  
  [cmdletbinding()]
  Param (
    [parameter(mandatory=$true)]
    [string]$StoredCredentialsPath
    )
  
  $UserName = Get-Content $StoredCredentialsPath | Select-Object -First 1
  $UserPassword = Get-Content $StoredCredentialsPath | Select-Object -Last 1 | ConvertTo-SecureString
  
  $StoredCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName,$UserPassword
  
  return $StoredCredentials
  }





# -------------------------------------
# execute a specified script remotely using user's credentials
# -------------------------------------

function Invoke-Remotely {
  
  [cmdletbinding()]
  Param(
    [parameter(mandatory=$true)]
    [string]$ComputerName,
    
    [parameter(mandatory=$true)]
    [scriptblock]$ScriptBlock,

    [parameter(mandatory=$false)]
    [object]$Credentials,

    [parameter(mandatory=$true)]
    [array]$Arguments
    )
  
  
  # create credentials if none are provided; build session
  if (!$Credentials) { $Credentials = Create-Credentials }
  $Session = New-PSSession -ComputerName $ComputerName -Credential $Credentials

  <#
  # path to ps1 functions to load remotely
  $CollectionOfFunctions = "Path\To\Functions"
  Invoke-Command -Session $Session -FilePath $CollectionOfFunctions
  #>
  
  # if scriptblock requires arguments, load here
  if ($Arguments) { $RemoteData = Invoke-Command -Session $Session -ScriptBlock $ScriptBlock -ArgumentList $Arguments }
    else { $RemoteData = Invoke-Command -Session $Session -ScriptBlock $ScriptBlock }
  
  
  # remove remote PS connection
  Remove-PSSession -Session $Session
  
  
  return $RemoteData
  }





  # -------------------------------------------------------------------------------------------------
  # -------------------------------------------------------------------------------------------------